class FacultyDigitalArchive < Ichabod::ResourceSet::Base
  self.prefix = 'fda'
  self.source_reader = :oai_dc_file_reader
  editor :fda_cataloger
  before_create :add_identifier_as_available_or_citation

  attr_reader :filename

  def initialize(*args)
    @filename = args.shift
    super
  end

  private
  def add_identifier_as_available_or_citation(*args)
    resource, nyucore = *args
    resource.identifier.each do |id|
      if id.include? "http://"
        nyucore.available = id
      else
        nyucore.citation = id
      end
    end
  end
end
