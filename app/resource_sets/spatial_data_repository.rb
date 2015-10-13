class SpatialDataRepository < Ichabod::ResourceSet::Base
  self.prefix = 'sdr'
  self.source_reader = :git_geo_blacklight_reader
  editor :gis_cataloger
  before_load :add_additional_info_link

  attr_reader :repo_url,:access_token
  alias_method :collection_code, :prefix

  def initialize(*args)
    @repo_url = args.shift
    @access_token = args.shift
    super
  end

private
  def add_additional_info_link(*args)
    nyucore = args.last
    nyucore.source_metadata.addinfolink = 'http://nyu.libguides.com/content.php?pid=169769&sid=1489817'
    nyucore.source_metadata.addinfotext = 'GIS Dataset Instructions'
  end
end
