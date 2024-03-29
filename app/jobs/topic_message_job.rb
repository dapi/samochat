# frozen_string_literal: true

# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# Отправляет топик посетителя в операторской гуппе сообщение
#
class TopicMessageJob < ApplicationJob
  queue_as :default

  def perform(visitor, message)
    visitor.project.bot.send_message(
      chat_id: visitor.project.telegram_group_id || raise("Project ##{visitor.project_id} has no telegram_group_id"),
      message_thread_id: visitor.telegram_message_thread_id || raise("Visitor ##{visitor.id} has no telegram_message_thread_id"),
      text: message
    )
  end
end
