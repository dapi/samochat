# frozen_string_literal: true

Bugsnag.configure do |config|
  config.api_key = '3d651ae5543617ed195775e716eac105'
  config.app_version = AppVersion.format('%M.%m.%p')
  config.notify_release_stages = %w[production]
  config.send_code = true
  config.send_environment = true
end