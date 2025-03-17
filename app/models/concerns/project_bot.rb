# frozen_string_literal: true

# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# Соглашение добавляет бота в модель проекта
#
# rubocop:disable  Metrics/ModuleLength
module ProjectBot
  extend ActiveSupport::Concern

  included do
    scope :with_bots, -> { where.not bot_token: nil }
    before_save do
      self.bot_id = bot_token.present? ? fetch_bot_id : ApplicationConfig.bot_id
    end

    after_commit if: :saved_change_to_bot_token?, on: %i[create update] do
      if bot_token?
        set_webhook
      else
        delete_webhook
      end
    end

    after_commit :delete_webhook, if: :bot_token?, on: :destroy
  end

  def custom_bot?
    bot_token.present?
  end

  def bot_token_required?
    tariff&.custom_bot_allowed?
  end

  def bot_token=(value)
    @bot = nil
    super
  end

  def fetch_chat_info
    return nil if telegram_group_id.nil?

    response = bot.get_chat chat_id: telegram_group_id
    # {"ok"=>true,
    # "result"=>
    # {"id"=>-1001803447845,
    # "title"=>"Paprika Dev Bot Support",
    # "type"=>"supergroup",
    # "permissions"=>
    # {"can_send_messages"=>true,
    # "can_send_media_messages"=>true,
    # "can_send_audios"=>true,
    # "can_send_documents"=>true,
    # "can_send_photos"=>true,
    # "can_send_videos"=>true,
    # "can_send_video_notes"=>true,
    # "can_send_voice_notes"=>true,
    # "can_send_polls"=>true,
    # "can_send_other_messages"=>true,
    # "can_add_web_page_previews"=>true,
    # "can_change_info"=>true,
    # "can_invite_users"=>true,
    # "can_pin_messages"=>true,
    # "can_manage_topics"=>true},
    # "join_to_send_messages"=>true}}
    response.is_a?(Hash) && response['ok'] ? response.fetch('result') : nil
  rescue Telegram::Bot::NotFound, Telegram::Bot::Error
    nil
  end

  def fetch_bot_id
    bot_token.to_s.split(':').first
  end

  def bot(force = false) # rubocop:disable Style/OptionalBooleanParameter
    @bot = nil if force
    @bot ||= bot_token.present? ? custom_bot : Telegram.bot
  end

  def custom_bot
    @custom_bot ||= Telegram::Bot::Client.new(bot_token, bot_username)
  end

  def set_webhook
    raise unless custom_bot?

    bot_id = fetch_bot_id
    url = Rails.application.routes.url_helpers.telegram_custom_webhook_url(bot_id)
    Rails.logger.info "[project_id=#{id}] Telegram set_webhook for #{bot_id} to #{url}"
    custom_bot.set_webhook(drop_pending_updates: false, url:) if bot_id.present?
  rescue Telegram::Bot::Error => e
    errors.add :bot_token, "Не верный токен. Доступа нет (#{e.message}."
  end

  def delete_webhook
    raise unless custom_bot?

    Rails.logger.info "[project_id=#{id}] Telegram delete_webhook for #{bot_id}"
    custom_bot.delete_webhook drop_pending_updates: false
  end

  # Бот подключен в группу?
  def bot_connected?
    bot_status.present?
    # bot_status == 'administrator'
  end

  def update_bot_member!(chat_member:, chat:)
    raise 'Project must be not changed' if changed?

    assign_attributes(
      telegram_chat: chat,
      telegram_group_is_forum: chat['is_forum'],
      telegram_group_type: chat.fetch('type'),
      bot_status: chat_member.fetch('status'),
      bot_can_manage_topics: chat_member['can_manage_topics'],
      chat_member:
    )
    return unless changed?

    self.chat_member_updated_at = Time.zone.now
    save!
  end

  # {"id"=>-1001803447845,
  # "title"=>"Paprika Dev Bot Support",
  # "type"=>"supergroup",
  # "permissions"=>
  # {"can_send_messages"=>true,
  # "can_send_media_messages"=>true,
  # "can_send_audios"=>true,
  # "can_send_documents"=>true,
  # "can_send_photos"=>true,
  # "can_send_videos"=>true,
  # "can_send_video_notes"=>true,
  # "can_send_voice_notes"=>true,
  # "can_send_polls"=>true,
  # "can_send_other_messages"=>true,
  # "can_add_web_page_previews"=>true,
  # "can_change_info"=>true,
  # "can_invite_users"=>true,
  # "can_pin_messages"=>true,
  # "can_manage_topics"=>true},
  # "join_to_send_messages"=>true}}
  def update_chat_info!(info)
    return if info.nil?

    assign_attributes(
      telegram_group_name: info.fetch('title'),
      telegram_group_type: info.fetch('type'),
      bot_can_manage_topics: info.dig('permissions', 'can_manage_topics')
      # TODO: Возможно можно вычислять
      # telegram_group_is_forum: chat['is_forum'],
      # bot_status: chat_member.fetch('status'),
    )
    return unless changed?

    save!
  end

  private

  def validate_bot_token
    if errors[:bot_token].present?
      self.name = self.bot_token = nil
      return
    end

    return unless bot_token?

    # {
    # "ok"=>true,
    # "result"=>{
    # "id"=>6177763867,
    # "is_bot"=>true,
    # "first_name"=>"LocalNuiChatBot",
    # "username"=>"LocalNuiChatBot",
    # "can_join_groups"=>true,
    # "can_read_all_group_messages"=>false,
    # "supports_inline_queries"=>false
    # }
    # }
    self.bot_username = custom_bot.get_me.dig('result', 'username') if bot_token_changed?
    self.name ||= bot_username
  rescue Telegram::Bot::NotFound
    errors.add :bot_token, 'Не действующий токен. Проверьте правильность ввода или создайте новый.'
  rescue Telegram::Bot::Error => e
    if e.message.include? 'Unauthorized'
      errors.add :bot_token, 'Не верный токен. Доступа нет.'
    else
      errors.add :bot_token, e.message
    end
  end
end
# rubocop:enable  Metrics/ModuleLength
