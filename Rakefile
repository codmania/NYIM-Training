# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)
require 'rake'
# rails >=3.0.8 will fix this
#https://github.com/jimweirich/rake/issues/33
# Until rails is updated to work with Rake 0.9.x, put the following in your project Rakefile before the call to Application.load_tasks:
class Rails::Application
  include Rake::DSL if defined?(Rake::DSL)
end

Nyim::Application.load_tasks
