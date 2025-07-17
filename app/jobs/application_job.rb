# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

# Базовый класс job-ов
class ApplicationJob < ActiveJob::Base
  self.enqueue_after_transaction_commit = true

  Retry = Class.new StandardError

  # Automatically retry jobs that encountered a deadlock
  retry_on ActiveRecord::Deadlocked
  retry_on Retry, wait: :exponentially_longer, attempts: 100

  # Telegram::Bot::Error: Bad Request: Bad Request: message thread not found
  rescue_from Telegram::Bot::Error do |error|
    logger.error "#{error}: #{Rails.backtrace_cleaner.clean(error.backtrace)}"
    rescue_bot_error error
  end

  # Most jobs are safe to ignore if the underlying records are no longer available
  discard_on ActiveJob::DeserializationError
  # Telegram::Bot::Forbidden (Forbidden: bot was kicked from the supergroup chat)
  discard_on Telegram::Bot::Forbidden do |job, error|
    Rails.logger.error [name, job, error].join(' ')
    rescue_bot_forbidden error
  end

  include Rails.application.routes.url_helpers

  class << self
    def rescue_bot_forbidden(error)
      Bugsnag.notify error
      logger.error error
      # TODO
      # OperatorMessageJob.perform_later(visitor.project, "У меня нет доступа к группе #{visitor.project.telegram_group_id} (#{error.message})")
      # visitor.projects.update! last_error: error.message, last_error_at: Time.zone.now
    end

    def default_url_options
      Rails.application.config.action_controller.default_url_options
    end
  end

  private

  def rescue_bot_error(error)
    if error.message.include? 'message thread not found'
      logger.error error
      Bugsnag.notify error
      visitor.update! telegram_message_thread_id: nil

      # Too Many Requests: Too Many Requests: retry after 42
    elsif error.message.include? 'Too Many Requests'
      timeout = error.message.split.last.to_i
      retru_job wait: (timeout + rand(1..50)).seconds
    else
      logger.error error
      Bugsnag.notify error
      raise error
    end
  end

  def logger
    @logger ||= ActiveSupport::TaggedLogging.new(Rails.logger.dup).tagged self.class.name
  end
end
