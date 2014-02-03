require 'nokogiri'
require "active-fedora"
require "active_support" # This is just to load ActiveSupport::CoreExtensions::String::Inflections

namespace :hydra_nyu do

  desc "Run this guy, pipe into sort & wc, you get record count, plus field count for input file..."
  task :field_stats => :environment do
      # run this guy, pipe into sort & wc, you get record count, plus field count for input file...
      # example, for sdr data: 
      #charper@charper-ThinkPad-T530:~/hydra-nyu$ rake field_stats | sort | uniq -c
      #      1 144
      #    144 accessURL
      #    142 description
      #    142 edition
      #    144 hasVersion
      #    144 identifier
      #    144 isPartOf
      #    144 processing
      #    142 publisher
      #    144 title
      #    144 type

      ##Whooo! This works!!!!
      ##md = Nyucore.create(title: 'LION', publisher: 'New York City Dept. of City Planning', identifier: 'DSS.NYCDCP_DCPLION_10cav\DSS.Lion_GJK', available: 'http://magellan.home.nyu.edu/datasets/zips/NYCDCP_DCPLION_10CAV-Lion_GJK.zip', description: 'LION is a single line representation of New York City streets containing address ranges and other information.', edition: '10C', series: 'NYCDCP_DCPLION_10CAV', version: 'DSS.NYCDCP_DCPLION_10cav\DSS.Lion_GJK')
      #f = File.open("/home/charper/Dropbox/strat43/sdr/sdr.xml")
      #f = File.open("/home/charper/strat43-data/hdl_2451_26402")
      f = File.open("/home/charper/strat43-data/stern.xml")
      doc = Nokogiri::XML(f)
      doc.xpath('//oai_dc:dc', 'oai_dc' => 'http://www.openarchives.org/OAI/2.0/oai_dc/')

      l = doc.xpath('//oai_dc:dc', 'oai_dc' => 'http://www.openarchives.org/OAI/2.0/oai_dc/')
      #puts len(l)
      for r in l do
          for child in r.children() do
              if child.name() != "text" && child.content() != ""
                  puts child.name()
              end
          end
      end
      puts l.length()
  end

  desc "Usage: rake load['sdr.xml','sdr']"
  task :load, [:fn, :prefix] => :environment do |t, args|

      # usage: rake load["/home/charper/Dropbox/strat43/sdr/sdr.xml","sdr"]
      ##Whooo! This works!!!!
      ##md = Nyucore.create(title: 'LION', publisher: 'New York City Dept. of City Planning', identifier: 'DSS.NYCDCP_DCPLION_10cav\DSS.Lion_GJK', available: 'http://magellan.home.nyu.edu/datasets/zips/NYCDCP_DCPLION_10CAV-Lion_GJK.zip', description: 'LION is a single line representation of New York City streets containing address ranges and other information.', edition: '10C', series: 'NYCDCP_DCPLION_10CAV', version: 'DSS.NYCDCP_DCPLION_10cav\DSS.Lion_GJK')
      f = File.open(args.fn)
      #f = File.open("/home/charper/strat43-data/hdl_2451_26402")
      doc = Nokogiri::XML(f)
      doc.xpath('//oai_dc:dc', 'oai_dc' => 'http://www.openarchives.org/OAI/2.0/oai_dc/')

      l = doc.xpath('//oai_dc:dc', 'oai_dc' => 'http://www.openarchives.org/OAI/2.0/oai_dc/')
      #puts len(l)
      for r in l do
      #now, for each record, I want to build an md hash, and load a core.
          md = {}
          ids = r.xpath('dc:identifier',  'dc' => 'http://purl.org/dc/elements/1.1/')
          for id in ids do
              if args.prefix == "sdr" then
                  pid = args.prefix + ":" + id.content().gsub('.', '-').gsub('\\', '-')
              elsif args.prefix = "fda" then
                  if id.content().include? "http://" then
                      pid = args.prefix + ":" + id.content().gsub('.', '-').gsub('\\', '-').gsub('http://', '').gsub('/', '-')
                  end
              end
          end
          core = Nyucore.new(:pid => pid)
          for child in r.children() do
              if child.name() == "identifier" then
                  if args.prefix == "sdr" then
                      core.identifier = child.content()
                  elsif args.prefix = "fda" then
                      if child.content().include? "http://" then
                          core.identifier = child.content()
                          core.available = child.content()
                      else
                          core.citation = child.content()
                      end
                  end
              end
              core.title = child.content() if child.name() == "title"
              core.creator = child.content() if child.name() == "creator"
              core.type = child.content() if child.name() == "type"
              core.publisher = child.content() if child.name() == "publisher"
              core.available = child.content() if child.name() == "accessURL"
              core.description = child.content().gsub('\\\'', '\'') if child.name() == "description"
              core.edition = child.content() if child.name() == "edition"
              core.series = child.content() if child.name() == "isPartOf"
              core.version = child.content() if child.name() == "hasVersion"
              core.date = child.content() if child.name() == "date"
              core.format = child.content() if child.name() == "format"
              core.language = child.content() if child.name() == "language"
              core.relation = child.content() if child.name() == "relation"
              core.rights = child.content() if child.name() == "rights"
              core.subject = child.content() if child.name() == "subject"

          end
          core.save
          puts "Loading '#{pid}'"
 
          #puts md.to_s

      end
      puts l.length()
  end

  desc "Run this guy, pipe into sort & wc, you get record count, plus field count for input file..."
  task :id_check, [:fn, :prefix] => :environment do |t, args|
      # run this guy, pipe into sort & wc, you get record count, plus field count for input file...
      # example, for sdr data: 
      #charper@charper-ThinkPad-T530:~/hydra-nyu$ rake field_stats | sort | uniq -c
      #      1 144
      #    144 accessURL
      #    142 description
      #    142 edition
      #    144 hasVersion
      #    144 identifier
      #    144 isPartOf
      #    144 processing
      #    142 publisher
      #    144 title
      #    144 type

      ##Whooo! This works!!!!
      ##md = Nyucore.create(title: 'LION', publisher: 'New York City Dept. of City Planning', identifier: 'DSS.NYCDCP_DCPLION_10cav\DSS.Lion_GJK', available: 'http://magellan.home.nyu.edu/datasets/zips/NYCDCP_DCPLION_10CAV-Lion_GJK.zip', description: 'LION is a single line representation of New York City streets containing address ranges and other information.', edition: '10C', series: 'NYCDCP_DCPLION_10CAV', version: 'DSS.NYCDCP_DCPLION_10cav\DSS.Lion_GJK')
      #f = File.open("/home/charper/Dropbox/strat43/sdr/sdr.xml")
      f = File.open(args.fn)
      #f = File.open("/home/charper/strat43-data/stern.xml")
      doc = Nokogiri::XML(f)
      doc.xpath('//oai_dc:dc', 'oai_dc' => 'http://www.openarchives.org/OAI/2.0/oai_dc/')

      l = doc.xpath('//oai_dc:dc', 'oai_dc' => 'http://www.openarchives.org/OAI/2.0/oai_dc/')
      #puts len(l)
      for r in l do
          for child in r.children() do
              if child.name() == "identifier" && child.content() != "" then
                  if args.prefix == "sdr" then
                      puts child.name + "|" + child.content()
                  end
              end
          end
          puts "---"
      end
      puts l.length()
  end

  desc "Usage: rake delete['sdr.xml','sdr']"
  task :delete, [:fn, :prefix] => :environment do |t, args|

      # usage: rake delete["/home/charper/Dropbox/strat43/sdr/sdr.xml","sdr"]
      f = File.open(args.fn)
      #f = File.open("/home/charper/strat43-data/hdl_2451_26402")
      doc = Nokogiri::XML(f)
      l = doc.xpath('//oai_dc:dc', 'oai_dc' => 'http://www.openarchives.org/OAI/2.0/oai_dc/')

      for r in l do
      #now, for each record, I want to build an md hash, and load a core.
          for child in r.children() do
              if child.name() == "identifier" then
                  if args.prefix == "sdr" then
                      pid = args.prefix + ":" + child.content().gsub('.', '-').gsub('\\', '-')
                  elsif args.prefix == "fda" then
                      pid = args.prefix + ":" + child.content().gsub('.', '-').gsub('\\', '-').gsub('http://', '').gsub('/', '-')
                  end
                  puts pid
                  result = ActiveFedora::FixtureLoader.delete(pid)
                  puts "Deleting '#{pid}' from #{ActiveFedora::Base.connection_for_pid(pid).client.url}" if result == 1
                
              end
          end
      end
  end

end