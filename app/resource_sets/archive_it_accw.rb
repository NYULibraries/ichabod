class ArchiveItAccw < Ichabod::ResourceSet::Base
  # N.B. limitations here: https://wiki.duraspace.org/display/FEDORA37/Fedora+Identifiers
  self.prefix = 'ai-accw'
  self.collection_title = "Archive of Contemporary Composers' Websites"
  self.source_reader = :archive_it_accw_reader
  editor :afc_group

  attr_reader :endpoint_url, :path
  alias_method :collection_code, :prefix

  def initialize(*args)
    @endpoint_url = args.shift
    @path         = args.shift || '/collections/4049.json'
    super
  end
end
