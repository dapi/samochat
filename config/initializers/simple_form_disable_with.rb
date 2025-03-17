# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

# Я думаю из описания понятно что это за модуль )
#
module DisableDoubleClickOnSimpleForms
  def submit(field, options = {})
    if field.is_a?(Hash)
      field[:data] ||= {}
      field[:data][:disable_with] ||= I18n.t('helpers.disable_with')
    else
      options[:data] ||= {}
      options[:data][:disable_with] ||= I18n.t('helpers.disable_with')
    end
    super
  end
end

SimpleForm::FormBuilder.prepend(DisableDoubleClickOnSimpleForms)
