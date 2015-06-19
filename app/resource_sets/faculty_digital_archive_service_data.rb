class FacultyDigitalArchiveServiceData < Ichabod::ResourceSet::Base
  self.prefix = 'fda'
  self.source_reader = :csv_file_reader
  editor :fda_cataloger
  before_load :set_available_or_citation

  attr_reader :resource_set, :file_path, :load_number_of_records, :header_map

  def initialize(*args)
    @file_path = args.shift
    @load_number_of_records = args.shift
    @chunk_size = args.shift
    @header_map = { :identifier=>["dc.identifier.uri"], :title=> ["dc.title" ], :creator=>["dc.contributor.author" ],:publisher=>["dc.publisher" ],
    :type=>["dc.type.resource","dc.type" ],:description=>["dc.description.abstract","dc.description" ],:date=>["dc.date.issued" ],:format=>["dc.format" ],
      :rights=>["dc.rights" ],:subject=>["dc.subject","dc.coverage","dc.coverage.temporal" ] }
    super
  end

  private
  def set_available_or_citation(*args)
    resource, nyucore = *args    
    nyucore.source_metadata.available = resource.identifier     
  end
end
