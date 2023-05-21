# frozen_string_literal: true

# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

module Telegram
  # Предтавляет посетителя в телеграм-сообщениях
  #
  class VisitorPresenter < ApplicationPresenter
    def username
      '@' + __getobj__.username # , ApplicationConfig::TELEGRAM_LINK_PREFIX + username
    end

    def last_visit_brief
      @last_visit_brief ||= brief_visit __getobj__.last_visit
    end

    def first_visit_brief
      @first_visit_brief ||= brief_visit __getobj__.first_visit
    end

    private

    def brief_visit(visit)
      return '' if visit.nil?

      [visit.referrer, visit.geo.presence, 'visit_data=' + visit.visit_data.to_json, 'page_data=' + visit.page_data.to_json]
        .compact
        .join(' ')
    end
  end
end
