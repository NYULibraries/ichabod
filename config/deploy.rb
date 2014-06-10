require 'nyulibraries/deploy/capistrano'

set :app_title, "ichabod"
if Rails.env.staging?
  set :keep_releases, 2
end

namespace :deploy do
  # task :create_symlink do
  #   run "rm -rf #{app_path}#{app_title} && ln -s #{current_path}/public #{app_path}#{app_title}"
  # end
  # task :create_current_path_symlink do
  #   run "rm -rf #{current_path} && ln -s #{current_release} #{current_path}"
  # end
  task :create_jetty_symlink do
    run "ln -s #{shared_path}/jetty #{current_path}/jetty"
  end
  # task :create_env_symlink do
  #   run "rm -rf #{current_path}/.env && ln -s #{shared_path}/.env #{current_path}/.env"
  # end
  # task :passenger_symlink do
  #  run "rm -rf #{current_path} && ln -s #{current_release} #{current_path}"
  # end
end

namespace :ingest do
  task :load_sdr do
    run "cd #{current_path}; bundle exec rake ichabod:load['./ingest/sdr.xml','sdr']"
  end
  task :load_fda do
    run "cd #{current_path}; bundle exec rake ichabod:load['./ingest/stern.xml','fda']"
  end
  task :delete_sdr do
    run "cd #{current_path}; bundle exec rake ichabod:delete['./ingest/sdr.xml','sdr']"
  end
  task :delete_fda do
    run "cd #{current_path}; bundle exec rake ichabod:delete['./ingest/stern.xml','fda']"
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
    run "cd #{previous_release}; bundle exec rake jetty:stop"
  end
  desc "Startup new jetty for current release"
  task :start do
    run "cd #{current_path}; bundle exec rake jetty:start"
  end
end

before "deploy", "jetty:stop"
after "deploy", "deploy:create_jetty_symlink", "jetty:start"

# after "deploy", "deploy:create_symlink", "deploy:create_current_path_symlink", "deploy:create_env_symlink"
