# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

# Pin npm packages by running ./bin/importmap

pin 'application', preload: true
pin '@hotwired/turbo-rails', to: 'turbo.min.js', preload: true
pin '@hotwired/stimulus', to: 'stimulus.min.js', preload: true
pin '@hotwired/stimulus-loading', to: 'stimulus-loading.js', preload: true
pin 'bootstrap', to: 'https://ga.jspm.io/npm:bootstrap@5.2.3/dist/js/bootstrap.esm.js'
# pin "bootstrap", to: "bootstrap.bundle.min.js"
pin '@popperjs/core', to: 'https://ga.jspm.io/npm:@popperjs/core@2.11.7/lib/index.js'
pin '@rails/actioncable', to: 'actioncable.esm.js'
# pin_all_from 'app/javascript/controllers', under: 'controllers'
# pin_all_from 'app/javascript/channels', under: 'channels'
# pin_all_from 'app/javascript/libs', under: 'libs'
pin '@hotwired/turbo-rails', to: 'turbo.min.js', preload: true
