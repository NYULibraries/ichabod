require 'nokogiri'
require 'active-fedora'
require 'active_support' # This is just to load ActiveSupport::CoreExtensions::String::Inflections
require 'webmock'
WebMock.allow_net_connect!

namespace :ichabod do

  desc "Run this guy, pipe into sort & wc, you get record count, plus field count for input file..."
  task :field_stats, [:filename, :prefix] => :environment do |t, args|
    Ichabod::DataLoader.new(args.filename, args.prefix).field_stats
  end

  desc "Usage: rake load['sdr.xml','sdr']"
  task :load, [:filename, :prefix] => :environment do |t, args|
    Ichabod::DataLoader.new(args.filename, args.prefix).load
  end

  desc "Usage: rake delete['sdr.xml','sdr']"
  task :delete, [:filename, :prefix] => :environment do |t, args|
    Ichabod::DataLoader.new(args.filename, args.prefix).delete
  end
end
