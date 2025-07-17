# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.4.2'

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem 'propshaft'
gem 'rails', '~> 8.0.2'

# Use postgresql as the database for Active Record
gem 'pg', '~> 1.1'

# Use the Puma web server [https://github.com/puma/puma]
gem 'puma', '<7'

# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem 'importmap-rails'

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem 'turbo-rails'

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem 'stimulus-rails'

# Use Redis adapter to run Action Cable in production
gem 'hiredis'
gem 'redis', '~> 4.0'

# Use the database-backed adapters for Rails.cache, Active Job, and Action Cable
gem 'solid_cable'
gem 'solid_cache'
gem 'solid_queue'
gem 'solid_queue_dashboard'

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', require: false

gem 'active_link_to'
gem 'anyway_config'
gem 'semver2', github: 'haf/semver'
gem 'slim-rails'
gem 'telegram-bot'

gem 'draper'
# gem 'env-tweaks', github: 'yivo/env-tweaks', branch: 'dependabot/bundler/activesupport-7.0.4.1'
gem 'simple_form'
gem 'strip_attributes'

gem 'request_store'

# Bundle and process CSS [https://github.com/rails/cssbundling-rails]
gem 'cssbundling-rails'

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem 'brakeman', require: false
  gem 'bundler-audit', require: false
  gem 'debug', platforms: %i[mri mingw x64_mingw]
  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'rubocop', require: false
  gem 'rubocop-capybara', require: false
  gem 'rubocop-rails', require: false
end

group :development do
  gem 'abbrev'
  gem 'bcrypt_pbkdf'
  gem 'ed25519'
  gem 'foreman'
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem 'web-console'

  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  # gem "rack-mini-profiler"

  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"
  gem 'guard'
  gem 'listen'
  gem 'terminal-notifier-guard'

  gem 'guard-ctags-bundler'
  gem 'guard-minitest'
  gem 'guard-rails'
  gem 'guard-rubocop', '~> 1.5'
  gem 'guard-shell', '~> 0.7.2'
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem 'capybara'
  gem 'selenium-webdriver'
  gem 'webdrivers'
end

gem 'sorcery', '~> 0.16.5'

gem 'nanoid', '~> 2.0'

gem 'validate_url', '~> 1.0'

gem 'geocoder', '~> 1.8'

gem 'bugsnag', '~> 6.25'

gem 'dotenv', '~> 2.8'
gem 'dotenv-rails', require: 'dotenv/rails-now'

gem 'russian', '~> 0.6.0'

gem 'telegram-bot-types'

# gem 'non-digest-assets', '~> 2.2'

# gem 'ransack', '~> 4.0'

# gem 'administrate', '~> 0.19.0'
# gem 'administrate-field-jsonb', '~> 0.4.6'

gem 'posthog-ruby', '~> 2.5'

gem 'base64', '~> 0.2.0'

gem 'bigdecimal', '~> 3.1'

gem 'mutex_m', '~> 0.3.0'

gem 'csv', '~> 3.3'

gem 'ostruct', '~> 0.6.1'

gem 'drb', '~> 2.2'

gem 'logger', '~> 1.7'

gem 'benchmark', '~> 0.4.0'

gem 'fiddle', '~> 1.1'

gem 'concurrent-ruby', '~> 1.3'

# gem 'sprockets-rails', '~> 3.5'

gem 'rails-i18n', '~> 8.0'
