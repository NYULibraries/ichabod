class TheLiberator < Ichabod::ResourceSet::Base
  self.prefix = 'theliberator'
  self.collection_title = "The Liberator"
  self.source_reader = :the_liberator_reader

  attr_reader :endpoint_url, :start, :rows
  alias_method :collection_code, :prefix

  def initialize(*args)
    @endpoint_url = args.shift
    @start = args.shift || '0'
    @rows = args.shift || '77'
    super
  end
end
