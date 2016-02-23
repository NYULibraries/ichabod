require 'figs'
Figs.load
namespace :tomcat do

  desc <<-DESC
Start tomcat server
  DESC
  task :startup => :environment do |t, args|
    exec( "sh #{ENV["TOMCAT_STARTUP_SCRIPT"]} ") if Figs.env.tomcat_startup_script?
  end

  desc <<-DESC
Shut down tomcat server
  DESC
  task :shutdown => :environment do |t, args|
    exec( "sh #{ENV["TOMCAT_SHUTDOWN_SCRIPT"]}") if Figs.env.tomcat_shutdown_script?
  end
end
