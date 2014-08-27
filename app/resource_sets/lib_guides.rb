class LibGuides < Ichabod::ResourceSet::Base
  self.prefix = 'libguides'
  self.source_reader = :lib_guides_xml_file_reader
  editor :libguides_cataloger

  attr_reader :filename

  def initialize(*args)
    @filename = args.shift
    super
  end
end
