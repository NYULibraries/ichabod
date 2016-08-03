# We need to bypass VCR in order to load data in the test environment
require 'webmock'
WebMock.allow_net_connect!

namespace :ichabod do

  desc <<-DESC
Read the Resources for a ResourceSet
Usage: rake read['resource_set_name','arg1','arg2',...,'argN'],
where resource_set_name is required and args are optional
  DESC
  task :read, [:name] => :environment do |t, args|
    data_loader = Ichabod::DataLoader.new(args.name, *args.extras)
    data_loader.read.each { |resource| p resource }
  end

  desc  <<-DESC
Load the Nyucores for a ResourceSet into Ichabod
Usage: rake load['resource_set_name','arg1','arg2',...,'argN'],
where resource_set_name is required and args are optional
  DESC
  task :load, [:name] => :environment do |t, args|
    data_loader = Ichabod::DataLoader.new(args.name, *args.extras)
    data_loader.load
  end

  desc  <<-DESC
Delete the Nyucores for a ResourceSet from Ichabod
Usage: rake delete['resource_set_name','arg1','arg2',...,'argN'],
where resource_set_name is required and args are optional
  DESC
  task :delete, [:name] => :environment do |t, args|
    data_loader = Ichabod::DataLoader.new(args.name, *args.extras)
    data_loader.delete
  end

  #task to create collections
  desc <<-DESC
Creates collection
Usage: rake create_collection['name',['Y'|'N']]
e.g.,  rake ichabod:create_collection['David Wojnarowicz Papers','Y']
  DESC
  task :create_collection, [:name,:discoverable] => :environment do |_, args|
    Collection.create({:title=>args.name,:discoverable=>args.discoverable})
  end

  #task to create collections
  desc <<-DESC
  test
  DESC
  task :test do
    puts "done"
  end



  # tasks operate directly on NYU Core objects
  namespace :nyucore do
    desc  <<-DESC
List Nyucores in Ichabod whose id attribute matches the specified pattern
Usage: rake list['pattern'],
e.g.,  rake ichabod:nyucore:list['sdr:DSS-ESRI_10_USA*']
    ,  rake ichabod:nyucore:list['sdr:*']
  DESC
    task :list, [:pattern] => :environment do |_, args|
      # escape colons in identifier pattern
      query_string = args.pattern.gsub(/:/, '\:')
      Nyucore.where("id:#{query_string}").each do |x|
        printf "%-64s %s\n", x.id, x.title
      end
    end

    desc  <<-DESC
Delete Nyucores in Ichabod whose id attribute matches the specified pattern
e.g.,  rake ichabod:nyucore:delete['sdr:DSS-ESRI_10_USA*']
    ,  rake ichabod:nyucore:delete['sdr:*']
  DESC
    task :delete, [:pattern] => :environment do |_, args|
      # escape colons in identifier pattern
      query_string = args.pattern.gsub(/:/, '\:')
      Nyucore.where("id:#{query_string}").each { |x| x.destroy }
    end
  end

end
