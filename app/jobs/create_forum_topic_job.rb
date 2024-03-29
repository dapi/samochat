# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

# Находит или создает топик операторской группе по пользователю
#
class CreateForumTopicJob < ApplicationJob
  queue_as :default

  Error = Class.new StandardError
  Retry = Class.new Error

  def perform(visitor, visit = nil)
    logger.info "create forum topic for #{visitor.id}"
    raise Error, "Visitor (#{visitor.id}) has no telegram_user_id" if visitor.telegram_user_id.nil?

    safe_perform visitor.project do
      visitor.with_lock do
        update_visitor! visitor, create_forum_topic_in_telegram!(visitor, build_topic_title(visitor, visit)) if visitor.telegram_message_thread_id.nil?
      end
    end
  end

  private

  def safe_perform(project)
    yield
  rescue Telegram::Bot::Error => e
    Bugsnag.notify e do |b|
      b.meta_data = { project_id: project.id }
    end
    logger.error e
    case e.message
    when 'Bad Request: Bad Request: chat not found'
      OperatorMessageJob.perform_later(project, "У меня нет доступа к группе [#{visitor.project.telegram_group_id}] (#{e.message})")
    when 'Bad Request: Bad Request: not enough rights to create a topic'
      # TODO: Снимать право с аттрибутов проекта
      OperatorMessageJob.perform_later(project, "У меня нет прав создавать топики для проекта ##{project.id}")
    when 'Bad Request: Bad Request: TOPIC_NOT_MODIFIED'
      # Do nothing
    else
      logger.warn e
      Bugsnag.notify e do |b|
        b.meta_data = { visitor: visitor.as_json }
      end
      OperatorMessageJob.perform_later(project, e.message)
    end
    raise Retry, e.message
  end

  def build_topic_title(visitor, visit = nil)
    TopicTitleBuilder.new(visitor, visit).build
  end

  # @param topic {"message_thread_id"=>11, "name"=>"94.232.57.6", "icon_color"=>7322096}}
  #
  def update_visitor!(visitor, topic)
    visitor.update!(
      telegram_message_thread_id: topic.fetch('message_thread_id'),
      telegram_cached_at: Time.zone.now,
      topic_data: topic
      # {"message_thread_id"=>11, "name"=>"94.232.57.6", "icon_color"=>7322096}}
    )
  end

  def create_forum_topic_in_telegram!(visitor, topic_title)
    topic = visitor.project.bot.create_forum_topic(
      chat_id: visitor.project.telegram_group_id || raise("no telegram_group_id in project #{visitor.project.id}"),
      name: topic_title
      # icon_color: ,
      # icon_custom_emoji_id
    )
    #  {"ok"=>true, "result"=>{"message_thread_id"=>11, "name"=>"94.232.57.6", "icon_color"=>7322096}}

    raise topic.to_json unless topic.fetch('ok') == true

    topic.fetch('result')
  end
end
