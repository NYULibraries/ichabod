class Voice < Ichabod::ResourceSet::Base
  self.prefix = 'beard'
  self.collection = "Voices of the Food Revolution"
  self.source_reader = :voice_reader

  attr_reader :endpoint_url
  alias_method :collection_code, :prefix

  def initialize(*args)
    @endpoint_url = args.shift
    super
  end
end
