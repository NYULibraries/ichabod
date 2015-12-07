class Woj < Ichabod::ResourceSet::Base
  self.prefix = 'woj'
  self.source_reader = :fab_reader

  attr_reader :endpoint_url, :page, :query
  alias_method :collection_code, :prefix

  def initialize(url, *args)
    @query = "?f%5Bcollection_sim%5D%5B%5D=David+Wojnarowicz+Papers&f%5Bdao_sim%5D%5B%5D=Online+Access&f%5Bformat_sim%5D%5B%5D=Archival+Object"
    @endpoint_url = url
    @page = args.shift
    super
  end
end
