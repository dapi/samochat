# frozen_string_literal: true

# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# Соглашения по авторизации и аутентификации для контроллеров
#
module Authentication
  extend ActiveSupport::Concern
  included do
    rescue_from NotAuthenticated, with: :not_authenticated
    rescue_from NotAuthorized, with: :not_authorized
  end

  private

  def simple_layout
    'simple' unless defined?(Admin) && is_a?(Admin::ApplicationController)
  end

  def not_authorized
    flash.now[:alert] = 'Вы не авторизованы'
    @back_url = root_url
    render 'not_authorized', layout: simple_layout, status: :forbidden
  end

  def not_authenticated
    flash.now[:alert] = 'Представьтесь, пожалуйста.'
    @back_url = root_url
    render 'not_authenticated', layout: simple_layout, status: :unauthorized
  end
end
