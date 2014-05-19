# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Ichabod::Application.load_tasks

# We need to add the coveralls task in the Rakefile
# because we want to make sure we append it to the very
# end of the default task
if Rails.env.test?
  # Add the coveralls task as the default with the appropriate prereqs
  require 'coveralls/rake/task'
  Coveralls::RakeTask.new
  task :default => [:spec, :test, :cucumber, 'coveralls:push']
end
