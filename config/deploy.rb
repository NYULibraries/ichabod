require 'formaggio/capistrano'

set :app_title, "ichabod"
set :new_relic_environments, nil  # do not use new_relic at this time

set :rvm_ruby_string, "ruby-2.1.3"

namespace :deploy do
  task :create_jetty_symlink do
    run "ln -s #{shared_path}/jetty #{current_path}/jetty"
  end
end

namespace :rosie do
  desc "Set variables for the Rosie the Riveter ingest tasks"
  task :set_variables do
    set :rosie_endpoint_url, ENV['ICHABOD_ROSIE_ENDPOINT_URL']
    set :rosie_user, ENV['ICHABOD_ROSIE_USER']
    set :rosie_password, ENV['ICHABOD_ROSIE_PASSWORD']

  end
  task :import do
    set_variables
    run "cd #{current_path}; RAILS_ENV=#{rails_env} bundle exec rake ichabod:load['rosie_the_riveter',#{rosie_endpoint_url},#{rosie_user},#{rosie_password}]"
  end
  task :delete do
    set_variables
    run "cd #{current_path}; RAILS_ENV=#{rails_env} bundle exec rake ichabod:nyucore:delete['rosie:*']"
  end
end

namespace :voice do
  desc "Set variables for the Voices of the Food Revolution ingest tasks"
  task :set_variables do
    set :voice_endpoint_url, ENV['ICHABOD_VOICE_ENDPOINT_URL']
  end
  task :import do
    set_variables
    run "cd #{current_path}; RAILS_ENV=#{rails_env} bundle exec rake ichabod:load['voice',#{voice_endpoint_url}]"
  end
  task :delete do
    set_variables
    run "cd #{current_path}; RAILS_ENV=#{rails_env} bundle exec rake ichabod:delete['voice',#{voice_endpoint_url}]"
  end
end

namespace :woj do
  task :import do
    run "cd #{current_path}; RAILS_ENV=#{rails_env} bundle exec rake ichabod:load['woj']"
  end
  task :delete do
    run "cd #{current_path}; RAILS_ENV=#{rails_env} bundle exec rake ichabod:nyucore:delete['woj:*']"
  end
end

namespace :fda_ngo do
  task :import do
    run "cd #{current_path}; RAILS_ENV=#{rails_env} bundle exec rake ichabod:load['faculty_digital_archive_ngo','./ingest/2451-33605.csv']"
  end
  task :delete do
    run "cd #{current_path}; RAILS_ENV=#{rails_env} bundle exec rake ichabod:delete['faculty_digital_archive_ngo','./ingest/2451-33605.csv']"
  end
end

namespace :archive_it_accw do
  desc "Set variables for the Archive It Archive of Contemporary Composers' Websites ingest tasks"
  task :set_variables do
    set :archive_it_accw_endpoint_url, ENV['ICHABOD_ARCHIVE_IT_ACCW_ENDPOINT_URL']
  end
  task :import do
    set_variables
    run "cd #{current_path}; RAILS_ENV=#{rails_env} bundle exec rake ichabod:load['archive_it_accw',#{archive_it_accw_endpoint_url}]"
  end
  task :delete do
    set_variables
    run "cd #{current_path}; RAILS_ENV=#{rails_env} bundle exec rake ichabod:delete['archive_it_accw',#{archive_it_accw_endpoint_url}]"
  end
end

namespace :nyupress do
  # desc "Set variables for the NYUPress Open Access Books ingest tasks"
  task :set_variables do
    set :nyupress_endpoint_url, ENV['ICHABOD_NYUPRESS_ENDPOINT_URL']
    set :nyupress_endpoint_rows, ENV['ICHABOD_NYUPRESS_ROWS']
    set :nyupress_endpoint_start, ENV['ICHABOD_NYUPRESS_START']
  end
  task :import do
    set_variables
    run "cd #{current_path}; RAILS_ENV=#{rails_env} bundle exec rake ichabod:load['nyu_press_open_access_book',#{nyupress_endpoint_url},#{nyupress_endpoint_start},#{nyupress_endpoint_rows}]"
  end
  task :delete do
    set_variables
    run "cd #{current_path}; RAILS_ENV=#{rails_env} bundle exec rake ichabod:delete['nyu_press_open_access_book',#{nyupress_endpoint_url},#{nyupress_endpoint_start},#{nyupress_endpoint_rows}]"
  end
end

namespace :masses do
  # desc "Set variables for The Masses ingest tasks"
  task :set_variables do
    set :masses_endpoint_url, ENV['ICHABOD_MASSES_ENDPOINT_URL']
  end
  
  task :import do
    set_variables
    run "cd #{current_path}; RAILS_ENV=#{rails_env} bundle exec rake ichabod:load['masses',#{masses_endpoint_url}]"
  end
  
  task :delete do
    set_variables
    run "cd #{current_path}; RAILS_ENV=#{rails_env} bundle exec rake ichabod:delete['masses',#{masses_endpoint_url}]"
  end
end

namespace :ingest do
  task :load_sdr do
    run "cd #{current_path}; RAILS_ENV=#{rails_env} bundle exec rake ichabod:load['spatial_data_repository',#{ENV['GIT_GEO_SPATIAL_MD_URL']},#{ENV['ICHABOD_GIT_USER_TOKEN']}]"
  end
  task :load_lib_guides do
    run "cd #{current_path}; RAILS_ENV=#{rails_env} bundle exec rake ichabod:load['lib_guides','./ingest/libguides.xml']"
  end
  task :load_service_data do
    run "cd #{current_path}; RAILS_ENV=#{rails_env} bundle exec rake ichabod:load['faculty_digital_archive_service_data','./ingest/2451-33611.csv']"
  end
  task :load_io_data do
    run "cd #{current_path}; RAILS_ENV=#{rails_env} bundle exec rake ichabod:load['indian_ocean_data','./ingest/IndianOcean_descMD_v01.csv']"
  end
  task :delete_sdr do
    run "cd #{current_path}; RAILS_ENV=#{rails_env} bundle exec rake ichabod:nyucore:delete['sdr:*']"
  end
  task :delete_fda do
    run "cd #{current_path}; RAILS_ENV=#{rails_env} bundle exec rake ichabod:delete['faculty_digital_archive','./ingest/stern.xml']"
  end
  task :delete_lib_guides do
    run "cd #{current_path}; RAILS_ENV=#{rails_env} bundle exec rake ichabod:delete['lib_guides','./ingest/libguides.xml']"
  end
  task :delete_service_data do
    run "cd #{current_path}; RAILS_ENV=#{rails_env} bundle exec rake ichabod:delete['faculty_digital_archive_service_data','./ingest/2451-33611.csv']"
  end
  task :delete_io_data do
    run "cd #{current_path}; RAILS_ENV=#{rails_env} bundle exec rake ichabod:delete['indian_ocean_data','./ingest/IndianOcean_descMD_v01.csv']"
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
