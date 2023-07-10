# frozen_string_literal: true

# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

class Payment < ApplicationRecord
  belongs_to :account
end
