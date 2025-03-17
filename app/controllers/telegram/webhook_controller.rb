# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

module Telegram
  # Контроллер бота.
  #
  class WebhookController < Bot::UpdatesController
    include UpdateProjectMembership
    include Commands::Start
    include Commands::Who
    include Actions::Message
    include Actions::MyChatMember
    include Telegram::RescueErrors

    use_session!

    before_action do
      @telegram_event = TelegramEvent.create! payload: update
    end

    private

    def current_bot_id
      bot.token.split(':').first
    end

    # Это пример нормальноо ответа от оператора в теме группы
    #
    # {
    # "update_id":124132842,
    # "message":{
    # "message_id":427,
    # "from":{"id":943084337,"is_bot":false,"first_name":"Danil","last_name":"Pismenny","username":"pismenny","language_code":"en"},
    # "chat":{"id":-1001989718457,"title":"kiiiosk.store","is_forum":true,"type":"supergroup"},
    # "date":1693674816,
    # "message_thread_id":407,
    # "reply_to_message":{
    # "message_id":407,
    # "from":{"id":5933409757,"is_bot":true,"first_name":"Nui Chat","username":"NuiChatBot"},
    # "chat":{"id":-1001989718457,"title":"kiiiosk.store","is_forum":true,"type":"supergroup"},
    # "date":1693583716,
    # "message_thread_id":407,
    # "forum_topic_created":{"name":"#129 Ivan Krasnoyarsk (Krasnoyarsk Krai/RU)","icon_color":7322096},
    # "is_topic_message":true
    # },
    # "text":"Согласен",
    # "is_topic_message":true
    # }
    # }

    # Это пример когда почему-то сообщение оператора в тему приходит от якобы ответа в главное теме.
    # Такой ответ нами не считывается, телеграммом перекидывается в general
    #
    # {
    # "update_id":124132841,
    # "message":{
    # "message_id":425,
    # "from":{"id":943084337,"is_bot":false,"first_name":"Danil","last_name":"Pismenny","username":"pismenny","language_code":"en"},
    # "chat":{"id":-1001989718457,"title":"kiiiosk.store","is_forum":true,"type":"supergroup"},
    # "date":1693674723,
    # "message_thread_id":1,
    # "reply_to_message":{
    # "message_id":411,
    # "from":{"id":5933409757,"is_bot":true,"first_name":"Nui Chat","username":"NuiChatBot"},
    # "chat":{"id":-1001989718457,"title":"kiiiosk.store","is_forum":true,"type":"supergroup"},
    # "date":1693639505,
    # "message_thread_id":411,
    # "forum_topic_created":{"name":"#130 Кирилл Amsterdam (North Holland/NL)","icon_color":7322096},
    # "is_topic_message":true
    # },
    # "text":"Добрый!",
    # "is_topic_message":true
    # }
    # }
    def topic_visitor
      return if chat_project.nil?

      chat_project.visitors.find_by(telegram_message_thread_id: topic_id)
    end

    def topic_id
      payload.fetch('message_thread_id')
    end

    # Топик создан или отредактирован
    # {
    # "update_id":797404202,
    # "message":{
    # "message_id":44,
    # "from":{"id":943084337,"is_bot":false,"first_name":"Danil","last_name":"Pismenny","username":"pismenny","language_code":"en"},
    # "chat":{"id":-1001927279455,"title":"Группа поддержи моего проекта!","is_forum":true,"type":"supergroup"},
    # "date":1693754470,
    # "message_thread_id":44,
    # "forum_topic_created":{"name":"Тестовый топик","icon_color":16766590},
    # "is_topic_message":true
    # }
    # }
    def forum_topic_action?
      forum_topic_created? || forum_topic_edited?
    end

    def forum_topic_created?
      payload.key?('forum_topic_created')
    end

    def forum_topic_edited?
      payload.key?('forum_topic_edited')
    end

    # Это означает что сообщение из группы, а не из личной перепики
    def forum?
      chat['is_forum'] || %w[group supergroup].include?(chat['type'])
    end

    def topic_message?
      payload['is_topic_message']
    end

    # Проект найденный по chat.id
    def chat_project
      @chat_project ||= Project.find_by(telegram_group_id: chat['id']) if forum?
    end

    def find_or_create_visitor(project)
      Visitor
        .create_or_find_by!(project:, telegram_user:)
    end

    # TODO: Если несколько visitor-ов то возможно имеет смысл спрашивать пользователя кому он отвечает
    # потому что иначе может ответить не туда
    # Например спрашивать в случае если совсем не давно ему кто-то отвечал
    def last_used_visitor
      if session[:project_id] && (project = Project.find_by(id: session[:project_id]))
        visitor = telegram_user.visitors.find_by(project_id: project.id)
      end
      visitor ||
        telegram_user.visitors.where.not(operator_replied_at: nil).order(:operator_replied_at).last ||
        telegram_user.visitors.order(:last_visit_at).last
    end

    def telegram_user
      @telegram_user ||= TelegramUser
        .create_with(chat.slice(*%w[first_name last_name username]))
        .create_or_find_by! id: chat.fetch('id')
    end

    def direct_client_message?
      from['id'] == chat['id'] && !from['is_bot'] && chat['type'] == 'private'
    end

    def notify_bugsnag(message)
      Rails.logger.warn message
      Bugsnag.notify message do |b|
        b.metadata = payload
      end
    end
  end
end
