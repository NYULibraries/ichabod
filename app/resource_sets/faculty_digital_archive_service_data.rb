class FacultyDigitalArchiveServiceData < Ichabod::ResourceSet::Base
  self.prefix = 'fda'
  self.source_reader = :csv_file_reader
  editor :fda_cataloger
  before_load :set_available_or_citation

  attr_reader :resource_set, :file_path, :load_number_of_records, :chunk_size

  def initialize(*args)
    @file_path = args.shift
    @load_number_of_records = args.shift
    @chunk_size = args.shift
    super
  end

  private
  def set_available_or_citation(*args)
    resource, nyucore = *args
    #identifiers = resource.identifier
    #identifiers.each do |identifier|
      #if identifier.include? "handle"
        nyucore.source_metadata.available = resource.identifier
      #else
        #nyucore.source_metadata.citation = identifier
      #end
    #end
  end
end
