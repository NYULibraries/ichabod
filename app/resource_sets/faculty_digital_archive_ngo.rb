
class FacultyDigitalArchiveNgo < Ichabod::ResourceSet::Base
  self.prefix = 'fda'
  self.source_reader = :oai_dc_http_reader
  editor :fda_cataloger
  before_load :set_available_or_citation, :set_type, :clean_dates

  attr_reader :endpoint_url, :set_handle, :load_number_of_records

  def initialize(*args)
    @endpoint_url = args.shift
    @set_handle = args.shift
    @load_number_of_records = args.shift
    super
  end

  private
  def set_available_or_citation(*args)
    resource, nyucore = *args
    identifiers = resource.identifier
    identifiers.each do |identifier|
      if identifier.include? "handle"
        nyucore.source_metadata.available = identifier
      else
        nyucore.source_metadata.citation = identifier
      end
    end
  end

  def set_type(*args)
    resource,nyucore = *args
    nyucore.type="Report"
  end

  def clean_dates(*args)
    resource,nyucore = *args
    resource.date.each.with_index do |raw_date,index|
      resource.date.delete(index) #if raw_date.to_s.include?("T")
    end
  end
end
