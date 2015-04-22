class SpatialDataRepository < Ichabod::ResourceSet::Base
  self.prefix = 'sdr'
  self.source_reader = :oai_dc_file_reader
  editor :gis_cataloger
  before_load :add_additional_info_link, :add_access_rights

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
    # hack to use controlled vocabulary only.
    nyucore.source_metadata.restrictions = I18n.t('restrictions.type.nyu_only') 
  end
end
