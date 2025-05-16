# frozen_string_literal: true

# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

if ENV.key? 'POSTHOG_API_KEY'
  PostHogClient = PostHog::Client.new({
                                        api_key: ENV.fetch('POSTHOG_API_KEY'),
                                        host: 'https://eu.posthog.com',
                                        on_error: proc { |_status, msg| Rails.logger.debug msg }
                                      })
end
