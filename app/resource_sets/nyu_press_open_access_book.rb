class NyuPressOpenAccessBook < Ichabod::ResourceSet::Base
  self.prefix = 'nyupress'
  self.collection = "NYU Press Open Access Books"
  self.source_reader = :nyu_press_open_access_book_reader

  attr_reader :endpoint_url, :start, :rows
  alias_method :collection_code, :prefix

  def initialize(*args)
    @endpoint_url = args.shift
    @start = args.shift || '0'
    @rows = args.shift || '65'
    super
  end
end
