# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

require 'custom_telegram_bot_middleware'
require 'admin_restriction'

Rails.application.routes.draw do
  constraints subdomain: ENV.fetch('ADMIN_SUBDOMAIN', 'admin') do
    constraints AdminRestriction do
      mount SolidQueueDashboard::Engine, at: '/solid-queue' if defined? SolidQueueDashboard
      #if defined? Administrate do
        #scope module: :admin, as: :admin do
          #resources :memberships
          #resources :messages
          #resources :projects
          #resources :tariffs
          #resources :telegram_events
          #resources :telegram_users
          #resources :users
          #resources :visits
          #resources :visitors
          #resources :visitor_sessions

          #root to: 'memberships#index'
        #end
      #end
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root 'welcome#index'

  telegram_webhook Telegram::WebhookController

  post 'telegram/custom_webhook/:custom_bot_id',
       to: CustomTelegramBotMiddleware.new(Telegram::WebhookController),
       as: :telegram_custom_webhook

  get 'telegram/auth_callback', to: 'telegram_auth_callback#create'
  get 'v', to: 'visit#create'
  get 'i', to: 'visit#logo'

  resources :sessions, only: %i[new create] do
    collection do
      delete :destroy
    end
  end

  resources :tariffs

  resources :projects do
    member do
      put :skip_widget
      put :reset_bot
    end
    resource :tariff, only: %i[show update], controller: 'projects/tariff'
    resource :widget, only: %i[show create], controller: 'projects/widget'
    resource :group, only: %i[show create], controller: 'projects/group'
    resources :visits, only: %i[index show], controller: 'projects/visits'
    resources :visitors, only: %i[index show], controller: 'projects/visitors'
  end

  match '*anything', to: 'application#not_found', via: %i[get post], constraints: { format: :html }
end
