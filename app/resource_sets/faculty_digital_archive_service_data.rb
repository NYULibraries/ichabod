class FacultyDigitalArchiveServiceData < Ichabod::ResourceSet::Base
  self.prefix = 'fda'
  self.collection = "Data Services"
  self.source_reader = :csv_file_reader
  editor :fda_cataloger 
  before_load :set_available_or_citation

  attr_reader :resource_set, :file_path, :header_map, :csv_reader_options

  def initialize(*args)
    @file_path = args.shift
    @csv_reader_options = {}
    @header_map = set_header_map
    super
  end

  private
  def set_available_or_citation(*args)
    resource, nyucore = *args    
    nyucore.source_metadata.available = resource.identifier     
  end

  def set_header_map
    { 
      identifier: ["identifier.uri"], title: ["title" ], creator: ["contributor.author" ], publisher: ["publisher" ],
      type: ["type" ], description: ["description.abstract","description" ], date: ["date.issued" ],
      format: ["format" ], rights: ["rights" ], subject: ["subject","coverage","coverage.temporal" ]
    }
  end
end
