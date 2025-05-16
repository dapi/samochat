# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

# A sample Guardfile
# More info at https://github.com/guard/guard#readme

notification :tmux, display_message: true

## Uncomment and set this to only include directories you want to watch
# rubocop:disable Lint/AmbiguousBlockAssociation
directories %w[app lib config test]
  .select { |d| Dir.exist?(d) ? d : UI.warning("Directory #{d} does not exist") }
# rubocop:enable Lint/AmbiguousBlockAssociation
## Uncomment and set this to only include directories you want to watch
# directories %w(app lib config test spec features) \
#  .select{|d| Dir.exist?(d) ? d : UI.warning("Directory #{d} does not exist")}

## Note: if you are using the `directories` clause above and you are not
## watching the project directory ('.'), then you will want to move
## the Guardfile to a watched dir and symlink it back, e.g.
#
#  $ mkdir config
#  $ mv Guardfile config/
#  $ ln -s config/Guardfile .
#
# and, you'll have to watch "config/Guardfile" instead of "Guardfile"

guard 'ctags-bundler', src_path: %w[app lib] do
  watch(%r{^(app|lib)/.*\.rb$})
  watch('Gemfile.lock')
end

group :development, halt_on_fail: true do
  guard :minitest do
    # with Minitest::Unit
    watch(%r{^test/(.*)/?test_(.*)\.rb$})
    watch(%r{^lib/(.*/)?([^/]+)\.rb$})     { |m| "test/#{m[1]}test_#{m[2]}.rb" }
    watch(%r{^test/test_helper\.rb$})      { 'test' }

    # with Minitest::Spec
    # watch(%r{^spec/(.*)_spec\.rb$})
    # watch(%r{^lib/(.+)\.rb$})         { |m| "spec/#{m[1]}_spec.rb" }
    # watch(%r{^spec/spec_helper\.rb$}) { 'spec' }

    watch(%r{^app/(.+)\.rb$})                               { |m| "test/#{m[1]}_test.rb" }
    watch(%r{^app/controllers/application_controller\.rb$}) { 'test/controllers' }
    watch(%r{^app/controllers/(.+)_controller\.rb$})        { |m| "test/integration/#{m[1]}_test.rb" }
    watch(%r{^app/views/(.+)_mailer/.+})                    { |m| "test/mailers/#{m[1]}_mailer_test.rb" }
    watch(%r{^lib/(.+)\.rb$})                               { |m| "test/lib/#{m[1]}_test.rb" }
    watch(%r{^test/.+_test\.rb$})
    watch(%r{^test/test_helper\.rb$}) { 'test' }
  end

  # guard :rubocop, all_on_start: false, cli: ['-D'] do
  # watch(/.+\.rb$/)
  # watch(%r{(?:.+/)?\.rubocop(?:_todo)?\.yml$}) { |m| File.dirname(m[0]) }
  # end

  # NOTE: The cmd option is now required due to the increasing number of ways
  #       rspec may be run, below are examples of the most common uses.
  #  * bundler: 'bundle exec rspec'
  #  * bundler binstubs: 'bin/rspec'
  #  * spring: 'bin/rspec' (This will use spring if running and you have
  #                          installed the spring binstubs per the docs)
  #  * zeus: 'zeus rspec' (requires the server to be started separately)
  #  * 'just' rspec: 'rspec'
end
