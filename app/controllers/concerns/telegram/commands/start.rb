# frozen_string_literal: true

# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

module Telegram
  module Commands
    # Команда /start
    #
    module Start
      def start!(visit_key = nil, *_args)
        if visit_key.to_s.start_with?(Visit::TELEGRAM_KEY_PREFIX) && (visit = Visit.includes(:visitor).find_by_telegram_key visit_key)
          start_client_visit! visit
        elsif (visitor = last_used_visitor)
          start_client_visit! create_visit visitor
        elsif (user = User.find_by(telegram_user_id: chat.fetch('id')))
          respond_with :message, text: "Привет, #{user.public_name}! Следуйте по ссылке #{Rails.application.routes.url_helpers.root_url}"
        else
          respond_with :message, text:
            ['Привет!',
             'Это сервис для поддержки пользователей через телеграм',
             "Чтобы подключиться следуйте по ссылке #{Rails.application.routes.url_helpers.root_url}"].join("\n")
        end
      end

      private

      def create_visit(visitor)
        VisitorSession
          .create_with(visitor:)
          .create_or_find_by!(
            cookie_id: 'telegram_id:' + telegram_user.id.to_s,
            project: visitor.project
          )
          .visits
          .create!(referrer: ApplicationConfig::TELEGRAM_LINK_PREFIX + ApplicationConfig.bot_username, remote_ip: '127.0.0.1', location: {})
      end

      def start_client_visit!(visit)
        visit.visitor_session.update! visitor: find_or_create_visitor(visit.visitor_session.project) if visit.visitor_session.visitor_id.nil?
        session[:project_id] = visit.project.id
        RegisterVisitJob.perform_later(visit:, chat:)
        text = WelcomeMessageBuilder.new(visit).build
        respond_with :message, text:
      end
    end
  end
end
