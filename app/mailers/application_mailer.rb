# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'from@example.com'
  layout 'mailer'
end
