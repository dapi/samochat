# frozen_string_literal: true

# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

require 'test_helper'

class TelegramUserTest < ActiveSupport::TestCase
  test 'the truth' do
    assert telegram_users(:bob).persisted?
  end
end
