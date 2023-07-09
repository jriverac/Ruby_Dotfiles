gem_group :development, :test do
  gem 'byebug', platform: :mri
  gem 'dotenv-rails'
  gem "factory_bot_rails"
  gem "pry-rails"
  gem "rubocop", require: false
  gem "rubocop-rails", require: false
  gem "rubocop-rspec", require: false
end


gem_group :development do
  gem 'guard', require: false
  gem 'guard-rspec', require: false
  gem 'rspec-core', require: false
  gem 'rspec-rails', require: false
  gem 'rspec-expectations', require: false
  gem 'rspec-mocks', require: false
end

gem_group :test do
  # TODO: What the hell is Launchy for?
  gem "launchy"
end

run "bundle install"

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

if yes? 'Do you wish to use Sorbet? (y/n)'
  gem 'dalli'
  run "bundle install"

  gem 'sorbet-runtime'

  gem_group :development do
    gem 'sorbet', :group => :development
    gem 'tapioca', require: false, :group => :development
  end

  run "bundle install"
  run "bundle exec tapioca init"
end
