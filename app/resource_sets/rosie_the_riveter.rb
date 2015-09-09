class RosieTheRiveter < Ichabod::ResourceSet::Base
  self.prefix = 'rosie'
  self.source_reader = :json_loader
  FORMAT = "Video"

  attr_reader :endpoint_url, :authentication, :datasource_params, :rsp_field, :each_rec_field, :set_data_map
  alias_method :collection_code, :prefix

  def initialize(*args)
    @endpoint_url = args.shift
    user = args.shift
    password = args.shift
    start = 0
    dataset_size = args.shift || 33
    @authentication = [user,password]
    @rsp_field = 'response'
    @each_rec_field = 'docs'
    @datasource_params = {start: start, rows: dataset_size, wt: 'json'}
    @set_data_map = set_rosie_map
    super
  end

  private
  def set_rosie_map
    {
      identifier: ['identifier'],
      title: ['entity_title'],
      available: ['metadata','handle','value'],
      citation: ['metadata','handle','value'],
      description: ['metadata','description','value','value'],
      type: FORMAT,
      format: FORMAT
    }
  end
end
