
class FacultyDigitalArchiveNgo < Ichabod::ResourceSet::Base
  self.prefix = 'fda'
  self.source_reader = :csv_file_reader
  editor :fda_cataloger
  before_load :set_available_or_citation, :set_type

  attr_reader :resource_set, :file_path, :header_map, :marc_order_for_publisher, :csv_reader_options

  def initialize(*args)
    @file_path = args.shift
    @csv_reader_options = {}
    @header_map = set_header_map
    @marc_order_for_publisher = true
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

  def set_header_map
    {
        identifier: ["identifier.uri","identifier.citation"], title: ["title" ], creator: ["contributor.author" ],
        description: ["description" ], date: ["date.issued" ], publisher: [["publisher.place","publisher","date.issued"],[":",","]],
        format: ["format" ], rights: ["rights" ], subject: ["subject" ], relation: ["identifier.citation"]
    }
  end
end
