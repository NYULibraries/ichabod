class SpatialDataRepository < Ichabod::ResourceSet::Base
  self.prefix = 'sdr'
  self.source_reader = :oai_dc_file_reader
  editor :gis_cataloger
  before_create :add_additional_info_link

  attr_reader :filename

  def initialize(*args)
    @filename = args.shift
    super
  end

  private
  def add_additional_info_link(*args)
    nyucore = args.last
    nyucore.addinfolink = 'http://nyu.libguides.com/content.php?pid=169769&sid=1489817'
    nyucore.addinfotext = 'GIS Dataset Instructions'
  end
end
