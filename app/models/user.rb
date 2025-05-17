# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

# Основная модель пользователя
#
class User < ApplicationRecord
  strip_attributes
  authenticates_with_sorcery!

  belongs_to :telegram_user
  has_many :memberships, dependent: :delete_all
  has_many :projects, through: :memberships, dependent: :delete_all
  has_one :account, inverse_of: :owner, dependent: :delete

  delegate :first_name, :public_name, :telegram_nick, to: :telegram_user

  def to_s
    public_name
  end

  def self.find_or_create_by_telegram_data!(data)
    find_or_create_by!(
      telegram_user: TelegramUser.find_or_create_by_telegram_data!(data)
    )
  end

  def self.authenticate(telegram_data)
    yield(
      User.find_or_create_by_telegram_data!(telegram_data),
      nil)
  end
end
