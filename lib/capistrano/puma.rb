# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

set :puma_enable_socket_service, true
set :puma_bind, -> { "unix://#{shared_path}/tmp/sockets/puma.sock" }
set :puma_service_unit_env_files, -> { "#{shared_path}/.env" }
