require 'nokogiri'
require 'active-fedora'
require 'active_support' # This is just to load ActiveSupport::CoreExtensions::String::Inflections
require 'webmock'
require 'pry'
WebMock.allow_net_connect!

namespace :ichabod do

  desc "Run this guy, pipe into sort & wc, you get record count, plus field count for input file..."
  task :read, [:name, :options] => :environment do |t, args|
    name = args.name
    options = eval(args.options)
    data_loader = Ichabod::DataLoader.new(name, options)
    records = data_loader.read
    records.each do |record|
      p record
    end
  end

  desc "Usage: rake load['spatial_data_repository','{filename:\"sdr.xml\"}']"
  task :load, [:name, :options] => :environment do |t, args|
    name = args.name
    options = eval(args.options)
    Ichabod::DataLoader.new(name, options).load
  end

  desc "Usage: rake delete['spatial_data_repository','{filename: \"sdr.xml\"}']"
  task :delete, [:name, :options] => :environment do |t, args|
    name = args.name
    options = eval(args.options)
    Ichabod::DataLoader.new(name, options).delete
  end
end
