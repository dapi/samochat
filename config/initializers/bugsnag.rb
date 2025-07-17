# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

Bugsnag.configure do |config|
  config.app_version = AppVersion.format('%M.%m.%p')
  config.notify_release_stages = %w[production]
  config.send_code = true
  config.send_environment = true
  config.hostname = ApplicationConfig.host
end
