class String
  def red; "\e[31m#{self}\e[0m" end

  def cyan; "\e[36m#{self}\e[0m" end
end

if defined?(Rails) && Rails.env.development?
  project_name = File.basename(Dir.pwd).cyan
  environment = ENV['RAILS_ENV'].red

  puts "Loading #{project_name} environment...".red
  puts "Ruby version: #{RUBY_VERSION}".red
  puts "Rails version: #{Rails.version}".red
  puts "RubyGems version: #{Gem::VERSION}".red
  puts "RubyGems paths: #{Gem.path}".red

  prompt = "#{project_name} [#{environment}] "

  IRB.conf[:PROMPT] ||= {}
  IRB.conf[:PROMPT][:RAILS_ENV] = {
    :PROMPT_I => "#{prompt}>> ",
    :PROMPT_N => "#{prompt}>> ",
    :PROMPT_S => "#{prompt}* ",
    :PROMPT_C => "#{prompt}?> ",
    :RETURN => "=> %s\n"
  }

  IRB.conf[:PROMPT_MODE] = :RAILS_ENV

  require 'awesome_print'
  AwesomePrint.irb!
end