# frozen_string_literal: true

# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

class PaymentCard < ApplicationRecord
  belongs_to :account
end
