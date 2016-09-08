require 'formaggio/capistrano'

set :app_title, "ichabod"
set :new_relic_environments, nil  # do not use new_relic at this time

set :rvm_ruby_string, "ruby-2.1.3"

namespace :deploy do
  task :create_jetty_symlink do
    run "ln -s #{shared_path}/jetty #{current_path}/jetty"
  end
end



namespace :cache do
  task :tmp_clear do
    # Do nothing
  end
end

namespace :jetty do
  desc "Shutdown previous version of jetty on server"
  task :stop do
    run "if [[ -d #{current_path} ]]; then cd #{current_path}; bundle exec rake jetty:stop ; else echo '#{current_path} DNE, skipping jetty:stop' ; fi"
  end
  desc "Startup new jetty for current release"
  task :start do
    run "cd #{current_path}; bundle exec rake jetty:start"
  end
end
