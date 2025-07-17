# frozen_string_literal: true

# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

module WidgetHelper
  EXAMPLE_CODE = '…'

  def widget_namespace
    ApplicationConfig.app_title.downcase
  end

  def widget_escape_param(value)
    if value == EXAMPLE_CODE
      value
    else
      CGI.escape value.to_json
    end
  end
end
