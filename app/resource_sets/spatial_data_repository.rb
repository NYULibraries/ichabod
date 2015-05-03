class SpatialDataRepository < Ichabod::ResourceSet::Base
  self.prefix = 'sdr'
  self.source_reader = :oai_dc_file_reader
  editor :gis_cataloger
  before_load :add_additional_info_link, :set_restriction_nyu_only

  attr_reader :filename

  def initialize(*args)
    @filename = args.shift
    super
  end

  private
  def add_additional_info_link(*args)
    nyucore = args.last
    nyucore.source_metadata.addinfolink = 'http://nyu.libguides.com/content.php?pid=169769&sid=1489817'
    nyucore.source_metadata.addinfotext = 'GIS Dataset Instructions'
  end

  def add_access_rights(*args)
    nyucore = args.last
    nyucore.source_metadata.restrictions = nyucore.source_metadata.restrictions[0]
  end
end
