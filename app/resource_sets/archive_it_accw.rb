class ArchiveItAccw < Ichabod::ResourceSet::Base
  # N.B. limitations here: https://wiki.duraspace.org/display/FEDORA37/Fedora+Identifiers
  self.prefix = 'ai-accw'
  self.source_reader = :archive_it_accw_reader

  attr_reader :endpoint_url
  alias_method :collection_code, :prefix

  def initialize(*args)
    @endpoint_url = args.shift
    super
  end
end
