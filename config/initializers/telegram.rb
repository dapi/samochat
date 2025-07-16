# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

Rails.application.config.telegram_updates_controller.session_store = :solid_cache_store

Telegram.bots_config = {
  default: {
    token: ApplicationConfig.bot_token,
    username: ApplicationConfig.bot_username, # to support commands with mentions (/help@ChatBot)
    id: ApplicationConfig.bot_id
  }
}

# Способ добавить новый вид payloads
# Telegram::Bot::UpdatesController::PAYLOAD_TYPES =  Telegram::Bot::UpdatesController::PAYLOAD_TYPES.dup + %w[]

if Rails.env.test?
  Telegram.reset_bots
  Telegram::Bot::ClientStub.stub_all!
  Telegram.bots_config = {
    default: {
      token: '12312:fake',
      username: 'fakebod'
    }
  }
end
