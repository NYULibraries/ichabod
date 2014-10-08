
class FacultyDigitalArchiveNgo < Ichabod::ResourceSet::Base
  self.prefix = 'fda'
  self.source_reader = :oai_dc_http_reader
  editor :fda_cataloger
  before_create :set_available_or_citation,:set_type

  attr_reader :endpoint_url,:set_handle

  def initialize(*args)
    @endpoint_url = args.shift
    @set_handle = args.shift
    super
  end

   private
  def set_available_or_citation(*args)
    resource, nyucore = *args
    identifiers = resource.identifier
    nyucore.identifier = identifiers.find do |identifier|
      if identifier.include? "handle"
        nyucore.available = identifier
      else
        nyucore.citation = identifier
      end
    end
  end

  def set_type(*args)
    resource,nyucore = *args
    nyucore.type="Technical Report"
  end

end
