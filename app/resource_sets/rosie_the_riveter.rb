class RosieTheRiveter < Ichabod::ResourceSet::Base
  self.prefix = 'rosie'
  self.source_reader = :rosie_the_riveter_reader

  attr_reader :endpoint_url, :user, :password
  alias_method :collection_code, :prefix

  def initialize(*args)
    @endpoint_url = args.shift
    @user = args.shift
    @password = args.shift
    super
  end
end
