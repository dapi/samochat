# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

# Базовый контроллер приложения
#
class ApplicationController < ActionController::Base
  include Authentication
end
