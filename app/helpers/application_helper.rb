# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

module ApplicationHelper
  def format_price(price)
    price.to_s + ' ₽'
  end

  def default_tariff_id
    @default_tariff_id ||= Tariff.find_by(is_default: true).id || raise('No default tariff found')
  end

  def setup_checkbox(flag, tooltip: nil)
    content_tag :span, title: tooltip || flag, data: { checkbox: true, checkbox_value: !!flag } do # rubocop:disable Style/DoubleNegation
      flag ? '✅' : '□' # '👁'
    end
  end

  def link_to_telegram_group(project)
    link_to project.telegram_group_name, project.telegram_group_url,
            target: '_blank',
            'data-bs-toggle': :tooltip,
            title: "ID Группы #{project.telegram_group_id}",
            rel: 'noopener'
  end

  def back_url
    params[:back_url] || @back_url # rubocop:disable Rails/HelperInstanceVariable
  end

  def spinner
    content_tag :div, class: 'spinner-border', role: 'status' do
      content_tag :span, class: 'visually-hidden' do
        'Loading...'
      end
    end
  end

  def link_to_project_bot(project)
    link_to_bot project.bot_username.presence || ApplicationConfig.bot_username
  end

  def link_to_bot(username = ApplicationConfig.bot_username)
    link_to '@' + username, ApplicationConfig::TELEGRAM_LINK_PREFIX + username, target: '_blank', rel: 'noopener'
  end

  def sort_column(column, title)
    return column unless defined? q

    sort_link q, column, title
  end

  def full_error_messages(form)
    return if form.object.errors.empty?

    content_tag :div, class: 'alert alert-danger' do
      form.object.errors.full_messages.to_sentence
    end
  end

  def hiden_columns
    []
  end

  delegate :app_title, to: :ApplicationConfig

  def back_link(url = nil)
    link_to "&larr; #{t('helpers.back')}".html_safe, url || root_path
  end

  def title_with_counter(title, count, hide_zero: true, css_class: nil)
    buffer = ''
    buffer += title

    buffer += ' '
    text = hide_zero && count.to_i.zero? ? '' : count.to_s
    buffer += content_tag(:span, "(#{text})", class: css_class, data: { title_counter: true, count: count.to_i }) if count.positive?

    buffer.html_safe
  end

  def controller_namespace
    return nil if controller.class.name.split('::').one?

    controller.class.name.split('::').first.underscore.to_sym
  end
end
