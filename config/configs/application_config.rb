# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

# Base class for application config classes
class ApplicationConfig < Anyway::Config
  TELEGRAM_LINK_PREFIX = 'https://t.me/'
  env_prefix :samochat
  attr_config(
    app_title: 'SamochatBot',
    host: 'localhost',
    protocol: 'https',
    bot_token: '',
    bot_username: ''
  )

  class << self
    # Make it possible to access a singleton config instance
    # via class methods (i.e., without explicitly calling `instance`)
    delegate_missing_to :instance

    def bot_url
      TELEGRAM_LINK_PREFIX + bot_username
    end

    def bot_id
      bot_token.split(':').first
    end

    def url
      protocol + '://' + host
    end

    private

    # Returns a singleton config instance
    def instance
      @instance ||= new
    end
  end
end
