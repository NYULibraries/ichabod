require 'nyulibraries/deploy/capistrano'

set :app_title, "ichabod"

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

namespace :rosie do
  # desc "Set variables for the Rosie the Riveter ingest tasks"
  task :set_variables do
    set :rosie_endpoint_url, ENV['ICHABOD_ROSIE_ENDPOINT_URL']
    set :rosie_user, ENV['ICHABOD_ROSIE_USER']
    set :rosie_password, ENV['ICHABOD_ROSIE_PASSWORD']
  end
  task :import do
    set_variables
    run "cd #{current_path}; bundle exec rake ichabod:load['rosie_the_riveter',#{rosie_endpoint_url},#{rosie_user},#{rosie_password}]"
  end
  task :delete do
    set_variables
    run "cd #{current_path}; bundle exec rake ichabod:delete['rosie_the_riveter',#{rosie_endpoint_url},#{rosie_user},#{rosie_password}]"
  end
end

namespace :ingest do
  task :load_sdr do
    run "cd #{current_path}; bundle exec rake ichabod:load['spatial_data_repository','./ingest/sdr.xml']"
  end
  task :load_fda do
    run "cd #{current_path}; bundle exec rake ichabod:load['faculty_digital_archive','./ingest/stern.xml']"
  end
  task :load_lib_guides do
    run "cd #{current_path}; bundle exec rake ichabod:load['lib_guides','./ingest/libguides.xml']"
  end
  task :delete_sdr do
    run "cd #{current_path}; bundle exec rake ichabod:delete['spatial_data_repository','./ingest/sdr.xml']"
  end
  task :delete_fda do
    run "cd #{current_path}; bundle exec rake ichabod:delete['faculty_digital_archive','./ingest/stern.xml']"
  end
  task :delete_lib_guides do
    run "cd #{current_path}; bundle exec rake ichabod:delete['lib_guides','./ingest/libguides.xml']"
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
    run "cd #{current_path}; bundle exec rake jetty:stop"
  end
  desc "Startup new jetty for current release"
  task :start do
    run "cd #{current_path}; bundle exec rake jetty:start"
  end
end

before "deploy", "jetty:stop"
after "deploy", "deploy:create_jetty_symlink", "jetty:start"

# after "deploy", "deploy:create_symlink", "deploy:create_current_path_symlink", "deploy:create_env_symlink"
