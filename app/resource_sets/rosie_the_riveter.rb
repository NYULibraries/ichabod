class RosieTheRiveter < Ichabod::ResourceSet::Base
  self.prefix = 'rosie'
  self.source_reader = :rosie_the_riveter_reader

  attr_reader :endpoint_url, :start, :rows 
  alias_method :collection_code, :prefix

  def initialize(*args)
    @endpoint_url = args.shift
    @start = args.shift || '0'
    @rows = args.shift || '100'
    super
  end
end
