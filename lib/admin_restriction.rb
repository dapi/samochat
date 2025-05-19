# frozen_string_literal: true

# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

class AdminConstraint
  def self.matches?(request)
    User.find_by_id(request.session[:user_id]).try &:superadmin?
  end
end
