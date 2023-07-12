# frozen_string_literal: true

# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

module Telegram
  # Отрабатываем ошибки телеграма
  module RescueErrors
    extend ActiveSupport::Concern
    included do
      rescue_from Telegram::Bot::Forbidden, with: :bot_forbidden
    end

    private

    # Пользователь написал в бота и заблокировал его (наверное добавлен где-то в канале или тп)
    def bot_forbidden(error)
      Rails.logger.error "#{error} #{params.to_json}"
    end
  end
end
