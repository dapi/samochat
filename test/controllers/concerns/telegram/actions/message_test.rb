# frozen_string_literal: true

# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

require 'test_helper'

class TelegramAtcionsMessage < TelegramControllerTestCase
  test 'уведомление что группа изменена' do
    dispatch TELEGRAM_UPDATES[:migrated]
    assert_includes sendMessageText, 'Теперь это супер-группа'
  end

  test 'сообщение от незнакомого пользователя' do
    dispatch TELEGRAM_UPDATES[:message_with_sticker]
    assert_includes sendMessageText, 'не знакомы'
  end

  test 'сообщение в general topic не определенному боту' do
    dispatch TELEGRAM_UPDATES[:general_topic_message]
    assert_includes sendMessageText, 'Кажись Вы меня не туда добавили, я Вас не знаю.'
  end

  test 'сообщение в general topic еще в одну группу с проектом к которому подключен бот' do
    project = projects(:yandex)
    bot = Minitest::Mock.new
    bot.expect :get_me, { 'result' => { 'username' => 'bot_name' } }
    bot.expect :set_webhook, nil, drop_pending_updates: false, url: Rails.application.routes.url_helpers.telegram_custom_webhook_url(Telegram.bot.token.split(':').first)
    Telegram::Bot::Client.stub :new, bot do
      project.update! bot_token: Telegram.bot.token
    end
    dispatch TELEGRAM_UPDATES[:general_topic_message]
    assert_includes sendMessageText, 'Кажись вы меня добавили еще в одну группу'
  end

  test 'сообщение в general topic с проектом к которому подключен бот' do
    project = projects(:dzen)
    bot = Minitest::Mock.new
    bot.expect :get_me, { 'result' => { 'username' => 'bot_name' } }
    bot.expect :set_webhook, nil, drop_pending_updates: false, url: Rails.application.routes.url_helpers.telegram_custom_webhook_url(Telegram.bot.token.split(':').first)
    Telegram::Bot::Client.stub :new, bot do
      project.update! bot_token: Telegram.bot.token, telegram_group_id: nil
    end
    dispatch TELEGRAM_UPDATES[:general_topic_message]
    assert_includes sendMessageText, 'Привет! Осталось дать мне право управлять темами'
  end
end
