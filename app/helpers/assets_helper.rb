# frozen_string_literal: true

# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# Помощники по ассетам
#
module AssetsHelper
  DIGEST_REGEXP = /(-{1}[a-z0-9]{32}*\.{1}){1}/
  def remove_asset_digest(path)
    path.sub(DIGEST_REGEXP, '.')
  end
end
