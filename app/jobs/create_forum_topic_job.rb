# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

# Находит или создает топик операторской группе по пользователю
#
class CreateForumTopicJob < ApplicationJob
  queue_as :default

  Error = Class.new StandardError

  def perform(visitor)
    raise Error, "Visitor (#{visitor.id}) has no telegram_id" if visitor.telegram_id.nil?

    safe_perform do
      visitor.with_lock do
        update_visitor! visitor, create_forum_topic_in_telegram!(visitor)
      end
    end
  end

  private

  def safe_perform
    yield
  rescue Telegram::Bot::Error => e
    Rails.logger.error e
    Bugsnag.notify e do |b|
      b.meta_data = { visitor: visitor.as_json }
    end
    case e.message
    when 'Bad Request: Bad Request: chat not found'
      # TODO: Похоже у бота нет доступа к группе, надо уведомить оператора
      # Telegram.bots[:operator].username
    when 'Bad Request: Bad Request: not enough rights to create a topic'
      # TODO
    when 'Bad Request: Bad Request: TOPIC_NOT_MODIFIED'
      # Do nothing
    else
      Rails.logger.warn e
      # TODO
    end
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

  def create_forum_topic_in_telegram!(visitor)
    topic = Telegram.bots[:operator].create_forum_topic(
      chat_id: visitor.project.telegram_group_id || raise("no telegram_group_id in project #{visitor.project.id}"),
      name: visitor.topic_title
      # icon_color: ,
      # icon_custom_emoji_id
    )
    #  {"ok"=>true, "result"=>{"message_thread_id"=>11, "name"=>"94.232.57.6", "icon_color"=>7322096}}

    raise topic.to_json unless topic.fetch('ok') == true

    topic.fetch('result')
  end
end