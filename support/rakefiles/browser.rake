require 'require_all'
require 'yaml'
require_all 'lib/db/models'

#Rake tasks for the browsers

desc 'Browser rake tasks'
namespace :browser do
  #rake task to start the sandbox
  desc 'Start the interactive ruby sandbox'
  task :start do
    irb_env_path = File.expand_path("../../irb_env.rb", __FILE__)
    system("irb -r #{irb_env_path}")
  end
end


#set the default rake task to the browser start. Running "bundle exec rake" will run this task
task default: 'browser:start'
