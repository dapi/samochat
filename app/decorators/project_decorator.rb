# frozen_string_literal: true

# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# Декоратор проекта
#
class ProjectDecorator < ApplicationDecorator
  delegate_all

  def bot_username
    h.link_to_bot(
      object.bot_username.presence || ApplicationConfig.bot_username
    )
  end

  def telegram_group_name
    return '-' if object.telegram_group_name.blank?

    h.link_to object.telegram_group_name, object.telegram_group_url
  end

  def title
    object.name
    # - if project.host.present?
    #= link_to project.host, project.url, target: '_blank'
    # - else
    # i Не установлено
  end

  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end
end
