class ArchiveItAccw < Ichabod::ResourceSet::Base
  # N.B. limitations here: https://wiki.duraspace.org/display/FEDORA37/Fedora+Identifiers
  self.prefix = 'ai-accw'
  self.source_reader = :archive_it_accw_reader
  editor :afc_group

  attr_reader :resource_set, :endpoint_url, :path, :datasource_params, :authentication

  def initialize(*args)
    url = args.shift
    @path         = args.shift || '/collections/4049.json'
    @endpoint_url = url + path
    super
  end
end
