# frozen_string_literal: true

# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

CloudPayments.configure do |c|
  # c.host = 'http://localhost:3000'    # By default, it is https://api.cloudpayments.ru
  c.public_key = ApplicationConfig.cloudpayments_public_key
  c.secret_key = ApplicationConfig.cloudpayments_secret_key
  c.log = !Rails.env.production?
  c.logger = ActiveSupport::Logger.new(Rails.root.join('log/cloudpayments.log'))
  c.raise_banking_errors = true
end

# Ошибка оплаты с человеческим лицом
class CloudPayments::Client::ReasonedGatewayError
  def message
    key = self.class.name.split('::').last
    I18n.t key, scope: 'errors.cloud_payments'
  end
end
