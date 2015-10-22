class FacultyDigitalArchiveNgo < Ichabod::ResourceSet::Base
  self.prefix = 'fda'
  self.collection = "Asian NGOs Reports"
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
  #The collection owner wants to exclude automatically created upload dates from the NYUcore metadata.
  # DSpace OAI interfeace returns all dates assosiated with an object in a "date" field. The only way to exclude the upload date is
  # to check it's format. Unlike user provided dates, upload dates contain time.
  #It looks like there are 2 ways to validate a date in ruby
  #1.try to convert it to a specific format and catch exception
  #2. evaluate the string using regex. Both are not perfect but 2 is faster
  def clean_dates(*args)
    resource,nyucore = *args
    resource.date.each do |raw_date|
         nyucore.source_metadata.date.delete(raw_date) if raw_date==~/[T,z]/
      end
  end
end
