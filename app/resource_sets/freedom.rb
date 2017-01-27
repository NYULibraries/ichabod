class Freedom < Ichabod::ResourceSet::Base
  self.prefix = 'fdm'
  self.collection_title = "Freedom"
  self.source_reader = :freedom_reader

  attr_reader :endpoint_url, :start, :rows
  alias_method :collection_code, :prefix

  def initialize(*args)
    @endpoint_url = args.shift
    @start = args.shift || '0'
    @rows = args.shift || '45'
    super
  end
end
