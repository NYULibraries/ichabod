class LibGuides < Ichabod::ResourceSet::Base
  self.prefix = 'libguides'
  self.collection = "Research Guides"
  self.source_reader = :lib_guides_xml_file_reader
  editor :libguides_cataloger

  attr_reader :filename
  alias_method :collection_code, :prefix

  def initialize(*args)
    @filename = args.shift
    super
  end
end
