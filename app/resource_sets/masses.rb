class Masses < Ichabod::ResourceSet::Base
  self.prefix = 'masses'
  self.collection_title = "The Masses"
  self.source_reader = :masses_reader

  attr_reader :endpoint_url, :resource_format, :resource_type, :start, :rows 
  alias_method :collection_code, :prefix

  def initialize(*args)
    @endpoint_url = args.shift
    @resource_format = "Book"
    @resource_type = "Book"
    @start = args.shift || 0
    @rows = args.shift || 100
    super
  end

end
