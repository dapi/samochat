# frozen_string_literal: true

# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# Форма единоразового пополнения баланса аккаунта через CloudPayments
class CloudPaymentsForm
  include ActiveModel::Model

  attr_accessor :name
  attr_accessor :recurrent
  attr_accessor :cryptogram_packet

  # Реально эти атрибуты никода не передаются используются только для генерации формы
  attr_accessor :cardNumber
  attr_accessor :expDateMonth
  attr_accessor :expDateYear
  attr_accessor :cvv

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
