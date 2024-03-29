# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

require 'test_helper'

class ProjectTest < ActiveSupport::TestCase
  fixtures :projects

  test 'project is persisted' do
    assert projects(:yandex).persisted?
  end
end
