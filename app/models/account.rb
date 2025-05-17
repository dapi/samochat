# frozen_string_literal: true

# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# Собствено аккаунт пользователя в системе с балансом
#
class Account < ApplicationRecord
  belongs_to :owner, class_name: 'User'

  has_many :invoices, dependent: :delete_all
  has_many :payments, dependent: :delete_all
  has_many :payment_cards, dependent: :delete_all
end
