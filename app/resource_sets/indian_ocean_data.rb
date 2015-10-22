class IndianOceanData < Ichabod::ResourceSet::Base
  self.prefix = 'io'
  self.collection = "Indian Ocean Postcards"
  self.source_reader = :csv_file_reader
  editor :io_cataloger
  before_load :set_available_or_citation, :set_title_for_untitled

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

  def set_title_for_untitled(*args)
    resource, nyucore = *args
    if nyucore.title.blank?
      nyucore.native_metadata.title = 'Untitled'
    end
  end

  def set_header_map
    { 
      identifier: ["handle"], title: ["title"], creator: ["creator"], contributor: ["contributor"],
      publisher: ["publisher", "publisher Location"], type: ["typeofresource"],
      description: ["description" ], date: ["date"], genre: ["genre"],
      subject: ["subject","tags","geographic_location"]
    }
  end
end
