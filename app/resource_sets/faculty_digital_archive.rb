class FacultyDigitalArchive < Ichabod::ResourceSet::Base
  self.prefix = 'fda'
  self.collection = "Faculty Digital Archive"
  self.source_reader = :oai_dc_file_reader
  editor :fda_cataloger
  before_load :add_identifier_as_available_or_citation, :set_http_identifier

  attr_reader :filename

  def initialize(*args)
    @filename = args.shift
    super
  end

  private
  def add_identifier_as_available_or_citation(*args)
    resource, nyucore = *args
    identifiers = resource.identifier
    identifiers.each do |identifier|
      if identifier.starts_with? "http://"
        nyucore.source_metadata.available = identifier
      else
        nyucore.source_metadata.citation = identifier
      end
    end
  end

  def set_http_identifier(*args)
    resource, nyucore = *args
    identifiers = resource.identifier
    nyucore.source_metadata.identifier = identifiers.find do |identifier|
      identifier.starts_with? 'http://'
    end
  end
end
