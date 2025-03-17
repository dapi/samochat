# frozen_string_literal: true

# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>
# Базовый декоратор
#
class ApplicationDecorator < Draper::Decorator
  TEXT_RIGHT = %i[balance balance_money].freeze
  ACTIVE_STATUS_CLASSES = { false => 'badge badge-danger',
                            true => 'badge badge-success' }.freeze

  def self.table_columns
    object_class.attribute_names.map(&:to_sym)
  end

  def self.table_th_class(column)
    'text-right' if TEXT_RIGHT.include? column.to_sym
  end

  def self.table_td_class(column)
    table_th_class column
  end

  def self.table_tr_class(record); end

  def self.attributes
    table_columns
  end

  def updated_at
    present_time object.updated_at
  end

  def created_at
    present_time object.created_at
  end

  private

  def monospace(buffer, css_class: nil)
    h.content_tag :span, buffer, class: "text-nowrap text-monospace #{css_class}"
  end

  def present_time(time)
    return if time.nil?
    return time.iso8601 if h.request.format.xlsx?

    h.content_tag :span, class: 'text-nowrap' do
      I18n.l time, format: :long
    end
  end
end
