class Woj < Ichabod::ResourceSet::Base
  self.prefix = 'woj'
  self.source_reader = :fab_reader

  attr_reader :page, :data_params
  alias_method :collection_code, :prefix

  def initialize(*args)
  	@data_params = { "f[collection_sim][]" => 'David Wojnarowicz Papers',
  	            		 "f[dao_sim][]"        => 'Online Access',
  	                 "f[format_sim][]"     => 'Archival Object'
 	                 }
    @page = args.shift
    super
  end
end
