require 'nokogiri'

task :greet do 
    puts "Hello World"
end

## So, => :environment as a dependency loads your rails env.
# What if more than one, can I do => :environmnet
    
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
    f = File.open("/home/charper/Dropbox/strat43/sdr/sdr.xml")
    #f = File.open("/home/charper/strat43-data/hdl_2451_26402")
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


task :load => :environment do


    ##Whooo! This works!!!!
    ##md = Nyucore.create(title: 'LION', publisher: 'New York City Dept. of City Planning', identifier: 'DSS.NYCDCP_DCPLION_10cav\DSS.Lion_GJK', available: 'http://magellan.home.nyu.edu/datasets/zips/NYCDCP_DCPLION_10CAV-Lion_GJK.zip', description: 'LION is a single line representation of New York City streets containing address ranges and other information.', edition: '10C', series: 'NYCDCP_DCPLION_10CAV', version: 'DSS.NYCDCP_DCPLION_10cav\DSS.Lion_GJK')
    f = File.open("/home/charper/Dropbox/strat43/sdr/sdr.xml")
    #f = File.open("/home/charper/strat43-data/hdl_2451_26402")
    doc = Nokogiri::XML(f)
    doc.xpath('//oai_dc:dc', 'oai_dc' => 'http://www.openarchives.org/OAI/2.0/oai_dc/')

    l = doc.xpath('//oai_dc:dc', 'oai_dc' => 'http://www.openarchives.org/OAI/2.0/oai_dc/')
    #puts len(l)
    for r in l do
    #now, for each record, I want to build an md hash, and load a core.
    md = {}
        for child in r.children() do
            md["title"] = child.content() if child.name() == "title"
            md["type"] = child.content() if child.name() == "type"
            md["identifier"] = child.content() if child.name() == "identifier"
            md["publisher"] = child.content() if child.name() == "publisher"
            md["available"] = child.content() if child.name() == "accessURL"
            md["description"] = child.content() if child.name() == "description"
            md["edition"] = child.content() if child.name() == "edition"
            md["series"] = child.content() if child.name() == "isPartOf"
            md["version"] = child.content() if child.name() == "hasVersion"
        end
        core = Nyucore.create(md) 

    end
    puts l.length()
end
