class Freedom < Ichabod::ResourceSet::Base
  self.prefix = 'fdm'
  self.collection_title = "Freedom"
  self.source_reader = :tamiment_journal_reader

  attr_reader :endpoint_url, :journal, :start, :rows
  alias_method :collection_code, :prefix

  def initialize(*args)
    @endpoint_url = args.shift
    @journal = self.collection_title
    @start = args.shift || '0'
    @rows = args.shift || '45'
    super
  end
end
