# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

# Членство пользователя в проекте и его роль
#
class Membership < ApplicationRecord
  belongs_to :user
  belongs_to :project
end
