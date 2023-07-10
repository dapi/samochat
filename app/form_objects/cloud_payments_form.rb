# frozen_string_literal: true

# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# Форма единоразового пополнения баланса аккаунта через CloudPayments
class CloudPaymentsForm
  include Virtus::Model
  include ActiveModel::Validations

  attribute :name, String
  attribute :recurrent, Boolean, default: true
  attribute :cryptogram_packet, String

  # Реально эти атрибуты никода не передаются используются только для генерации формы
  attribute :cardNumber, String
  attribute :expDateMonth, String
  attribute :expDateYear, String
  attribute :cvv, String

  validates :name, presence: true
  validates :cryptogram_packet, presence: true

  def persisted?
    false
  end

  def to_key
    nil
  end

  private

  def nilify_blanks(options = {})
    keys = options[:only] ||= self.keys
    keys.each do |key|
      self[key] = nil if self[key].blank?
    end
  end
end
