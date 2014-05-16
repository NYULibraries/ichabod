module Ichabod
  class DataLoader
    def initialize(filename, prefix)
      file = File.open(filename)
      doc = Nokogiri::XML(file)
      @records = doc.xpath('//oai_dc:dc', 'oai_dc' => 'http://www.openarchives.org/OAI/2.0/oai_dc/')
      @prefix = prefix
    end

    def   field_stats
      for record in @records do
        for child in record.children() do
          if child.name() != "text" && child.content() != ""
            puts child.name()
          end
        end
      end
      puts @records.length()
    end

    def load
      for record in @records do
        md = {}
        ids = record.xpath('dc:identifier',  'dc' => 'http://purl.org/dc/elements/1.1/')
        for id in ids do
            if @prefix == "sdr" then
              pid = @prefix + ":" + id.content().gsub('.', '-').gsub('\\', '-')
            elsif @prefix == "fda" then
              if id.content().include? "http://" then
                pid = @prefix + ":" + id.content().gsub('.', '-').gsub('\\', '-').gsub('http://', '').gsub('/', '-')
              end
            end
        end
        core = Nyucore.new(:pid => pid)
        for child in record.children() do
          if child.name() == "identifier" then
            if @prefix == "sdr" then
              core.identifier = child.content()
            elsif @prefix == "fda" then
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

      end
    end

        
    def delete

      # usage: rake delete["/home/charper/Dropbox/strat43/sdr/sdr.xml","sdr"]

      for record in @records do
      #now, for each record, I want to build an md hash, and load a core.
        for child in record.children() do
          if child.name() == "identifier" then
            if @prefix == "sdr" then
              pid = @prefix + ":" + child.content().gsub('.', '-').gsub('\\', '-')
            elsif @prefix == "fda" then
              pid = @prefix + ":" + child.content().gsub('.', '-').gsub('\\', '-').gsub('http://', '').gsub('/', '-')
            end
            puts pid
            result = ActiveFedora::FixtureLoader.delete(pid)
            puts "Deleting '#{pid}' from #{ActiveFedora::Base.connection_for_pid(pid).client.url}" if result == 1
          end
        end
      end
    end
  end
end
