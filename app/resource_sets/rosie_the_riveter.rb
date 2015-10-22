class RosieTheRiveter < Ichabod::ResourceSet::Base
  self.prefix = 'rosie'
  self.collection = "The Real Rosie the Riveter"
  self.source_reader = :rosie_the_riveter_reader

  attr_reader :endpoint_url, :user, :password, :dataset_size
  alias_method :collection_code, :prefix

  def initialize(*args)
    @endpoint_url = args.shift
    @user = args.shift
    @password = args.shift
    @dataset_size = args.shift || 33
    super
  end
end
