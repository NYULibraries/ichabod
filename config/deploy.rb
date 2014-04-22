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
  task :passenger_symlink do
    # run "rm -rf #{current_path} && ln -s #{current_release} #{current_path}"
  end
end

namespace :ingest do
  task :load_xml_data do
    run "bundle exec rake ichabod:load[./ingest/sdr.xml,sdr]"
    run "bundle exec rake ichabod:load[./ingest/stern.xml,fda]"
  end
  task :clean_xml_data do
    run "bundle exec rake ichabod:delete[./ingest/sdr.xml,sdr]"
    run "bundle exec rake ichabod:delete[./ingest/stern.xml,fda]"
  end
end

namespace :cache do
  task :tmp_clear do
    # Do nothing
  end
end

after "deploy", "deploy:create_jetty_symlink"

# after "deploy", "deploy:create_symlink", "deploy:create_current_path_symlink", "deploy:create_env_symlink"
