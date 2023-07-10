# frozen_string_literal: true

# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# Счет на оплату пользования сервисом
#
class Invoice < ApplicationRecord
  belongs_to :account

  validates :amount, numericality: { greater_than: 0 }

  def fully_paid?
    fully_paid_at?
  end

  def title
    'Оплата услуг'
  end

  def description
    'Абонентская плата'
  end
end
