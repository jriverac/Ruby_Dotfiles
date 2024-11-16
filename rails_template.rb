gem 'newrelic_rpm'

gem_group :development, :test do
  gem 'byebug', platform: :mri
  gem 'dotenv-rails'
  gem "factory_bot_rails"
  gem "rubocop", require: false
  gem "rubocop-rails", require: false
  gem "rubocop-rspec", require: false
  gem "rubocop-rake", require: false
  gem 'rubocop-factory_bot', require: false
  # gem 'ruby_jard', require: false
  # gem 'pry-rails'
  # gem 'pry-byebug'
  # gem 'pry-doc'
  # gem 'pry-stack_explorer'
end

gem_group :development do
  gem 'guard', require: false
  gem 'guard-rspec', require: false
  gem 'rspec-core', require: false
  gem 'rspec-rails', require: false
  gem 'rspec-expectations', require: false
  gem 'rspec-mocks', require: false
  gem 'annotate'
  gem 'reek'
end

gem_group :test do
  # NOTE: What the hell is Launchy for?
  gem "launchy"
end

run "bundle install"
run "bundle binstubs rspec-core"
run "bundle binstubs rubocop"

if yes? 'Do you wish to generate a root controller? (y/n)'
  name = ask('What do you want to call it?').to_s.underscore
  generate :controller, "#{name} show"
  route "root to: '#{name}\#show'"
  route "resource :#{name}, controller: :#{name}, only: [:show]"
end

run "rails generate rspec:install"

guardfile = <<-EOL
guard :rspec, cmd: 'bundle exec rspec' do
  watch('spec/spec_helper.rb')                        { "spec" }
  watch('spec/rails_helper.rb')                       { "rails spec" }
  watch('config/routes.rb')                           { "spec/routing" }
  watch('app/controllers/application_controller.rb')  { "spec/controllers" }
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^app/(.+)\.rb$})                           { |m| "spec/\#{m[1]}_spec.rb" }
  watch(%r{^app/(.*)(\.erb|\.haml|\.slim)$})          { |m| "spec/\#{m[1]}\#{m[2]}_spec.rb" }
  watch(%r{^lib/(.+)\.rb$})                           { |m| "spec/lib/\#{m[1]}_spec.rb" }
  watch(%r{^app/controllers/(.+)_(controller)\.rb$})  { |m| ["spec/routing/\#{m[1]}_routing_spec.rb", "spec/\#{m[2]}s/\#{m[1]}_\#{m[2]}_spec.rb", "spec/acceptance/\#{m[1]}_spec.rb"] }
end
EOL

create_file "Guardfile", guardfile

editorconfig = <<-EOL
# EditorConfig is awesome: https://EditorConfig.org

# top-most EditorConfig file
root = true

[*]
indent_style = space
indent_size = 2
end_of_line = lf
charset = utf-8
trim_trailing_whitespace = true
insert_final_newline = true

[Makefile]
indent_style = tab
indent_size = 4
EOL

create_file ".editorconfig", editorconfig

vsc_settings_json = <<-EOL
{
  "ruby.rubocop.executePath": "bin/",
  "ruby.rubocop.useBundler": false,
  "ruby.rubocop.configFilePath": ".rubocop.yml",
  "todo-tree.highlights.defaultHighlight": {
    "icon": "alert",
    "type": "text",
    "foreground": "#ff0000",
    "background": "#ffffff",
    "opacity": 50,
    "iconColour": "#0000FF"
  },
  "todo-tree.general.tags": [
    "TODO",
    "[ ]",
    "[x]",
    "FIXME",
    "HACK"
    "NOTE",
    "BUG"
  ],
  "todo-tree.highlights.customHighlight": {
    "TODO": {
      "icon": "checkbox",
      "type": "line",
      "iconColour": "#FF0000",
      "background": "#FFFF00",
      "foreground": "#FFFF00",
      "gutterIcon": true
    },
    "FIXME": {
      "foreground": "#FFFF00",
      "background": "#FF0000",
      "iconColour": "#FFFF00",
      "gutterIcon": true
    },
    "BUG": {
      "icon": "bug",
      "foreground": "#FFFF00",
      "background": "#FF0000",
      "iconColour": "#FFFF00",
      "fontWeight": "bold",
      "gutterIcon": true
    },
    "NOTE": {
      "icon": "note",
      "foreground": "#85a6ff",
      "background": "#4927c2",
      "iconColour": "#85a6ff",
      "gutterIcon": true
    },
    }
  },
  "todo-tree.general.periodicRefreshInterval": 5,
  "todo-tree.general.showIconsInsteadOfTagsInStatusBar": true,
  "todo-tree.general.tagGroups": {},
  "todo-tree.tree.showCountsInTree": true,
}
EOL

create_file ".vscode/settings.json", vsc_settings_json

vsc_tasks_json = <<-EOL
{

}
EOL

create_file ".vscode/tasks.json", vsc_tasks_json

vsc_launch_json = <<-EOL
{
  "configurations": [
  {
    "name": "Rails Server",
    "type": "Ruby",
    "request": "launch",
    "program": "${workspaceRoot}/bin/rails",
    "args": [
      "server"
    ]
  },
  {
    "name": "Ruby Debug RSpec",
    "type": "rdbg",
    "request": "launch",
    "cwd": "${workspaceRoot}/bin/rspec",
    "args": []
  },
  {
    "name": "Ruby Debug Rails",
    "type": "rdbg",
    "request": "launch",
    "cwd": "${workspaceRoot}/bin/rails",
    "args": [
      "server"
    ]
  }
  ]
}
EOL

vsc_launch_2_json = <<-EOL
{
  "configurations": [
  {
    "name": "Attach to Rails",
    "type": "rdbg",
    "request": "attach",
    "cwd": "${workspaceRoot}/bin/rails",
    "args": [
      "server"
    ]
  },
  {
    "name": "Debug Server",
    "type": "rdbg",
    "request": "launch",
    "script": "${workspaceRoot}/bin/rails",
    "args": [
      "server"
    ]
  },
  {
    "name": "Debug RSpec",
    "type": "rdbg",
    "request": "launch",
    "script": "${workspaceRoot}/bin/rspec",
    "args": []
  }
  ]
}
EOL

create_file ".vscode/launch.json", vsc_launch_2_json

ruby_jard = <<-EOL
config.color_scheme = "deep-space"
config.alias_to_debugger = true
config.layout = "wide"
config.enabled_screens = ['backtrace', 'source']
config.filter = :gems
config.filter_included = ['active*', 'sidekiq']
config.filter_excluded = ['acts-as-taggable-on']
config.key_bindings = {
  RubyJard::Keys::CTRL_N => 'next',
  RubyJard::Keys::CTRL_U => 'up',
  RubyJard::Keys::CTRL_D => 'down',
  RubyJard::Keys::META_S => 'step'
}
EOL

create_file ".jardrc", ruby_jard

setup_devise = <<-EOL
#!/bin/bash
bin/bundle add 'devise'

bin/rails generate devise:install
bin/rails generate devise User
bin/rails generate devise:views
EOL

create_file "setup_devise.sh", setup_devise

setup_sorbet = <<-EOL
#!/bin/bash

bin/bundle add dalli

bin/bundle add sorbet-runtime

bin/bundle add sorbet --group development
bin/bundle add tapioca --group development --require false

bin/bundle install

bin/bundle tapioca init
EOL

create_file "setup_sorbet.sh", setup_sorbet


rubocop_yml = <<-EOL
require:
  - rubocop-rails
  - rubocop-rake
  - rubocop-rspec
  - rubocop-factory_bot

AllCops:
  Exclude:
    - 'bin/**/*'
    - 'db/**/*'
    - 'node_modules/**/*'
EOL

create_file ".rubocop.yml", rubocop_yml

run "bin/rails generate rspec:install"
run "bin/rails css:install:bootstrap"

run "bin/rails db:create"
run "bin/rails db:migrate"

run "asdf local ruby 3.2.2"


run "bin/rubocop -A"
run "bin/rubocop --auto-gen-config"

run "rails app:update:bin"

after_bundle do
  git :init
  git add: '.'
  git commit: "-a -m 'Initial commit'"
end
