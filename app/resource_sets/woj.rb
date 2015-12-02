class Woj < Ichabod::ResourceSet::Base
  self.prefix = 'woj'
  self.source_reader = :fab_reader

  attr_reader :endpoint_url, :page
  alias_method :collection_code, :prefix

  def initialize(url, *args)
    @endpoint_url = url
    @page = args.shift
    super
  end
end
