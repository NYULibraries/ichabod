class NyuPressOpenAccessBook < Ichabod::ResourceSet::Base
  self.prefix = 'nyupress'
  self.source_reader = :nyu_press_open_access_book_reader

  attr_reader :endpoint_url
  alias_method :collection_code, :prefix

  def initialize(*args)
    @endpoint_url = args.shift
    super
  end
end
