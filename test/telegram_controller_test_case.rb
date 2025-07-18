# frozen_string_literal: true

# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

class TelegramControllerTestCase < ActiveSupport::TestCase
  setup do
    @bot = Telegram.bot
    @described_class = Telegram::WebhookController
    # route_name = Telegram::Bot::RoutesHelper.route_name_for_bot(@bot)
    # @controller_path = Rails.application.routes.url_helpers.public_send("#{route_name}_path")
    # @object = Class.new
    # @object.extend Telegram::Actions::Message
  end

  private

  # rubocop:disable Naming/MethodName
  def sendMessageText
    @bot.requests.fetch(:sendMessage).first.fetch(:text)
  end
  # rubocop:enable Naming/MethodName

  # Matcher to check response. Make sure to define `let(:chat_id)`.
  def respond_with_message(expected = Regexp.new(''))
    raise 'Define chat_id to use respond_with_message' unless defined?(chat_id)

    send_telegram_message(bot, expected, chat_id:)
  end

  def dispatch(update)
    @response = @described_class.dispatch @bot, ActiveSupport::HashWithIndifferentAccess.new(update)
  end

  def dispatch_message(text, options = {})
    default_message_options = {
      from: { id: @from_id || 123 },
      chat: { id: @chat_id || 456 }
    }
    dispatch message: default_message_options.merge(options).merge(text:)
  end

  # Dispatch command message.
  def dispatch_command(cmd, *args)
    options = args.last.is_a?(Hash) ? args.pop : {}
    args.unshift("/#{cmd}")
    dispatch_message(args.join(' '), options)
  end
end
