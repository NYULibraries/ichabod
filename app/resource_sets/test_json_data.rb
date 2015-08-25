class TestJsonData < Ichabod::ResourceSet::Base
  self.prefix = 'test'
  self.source_reader = :json_loader
  FORMAT = "Book"

  attr_reader :endpoint_url, :datasource_params, :authentication, :rsp_field, :each_rec_field, :set_data_map
  
  def initialize(*args)

    @endpoint_url = args.shift
    #user = args.shift
    #password = args.shift
    start = args.shift || '0'
    rows = args.shift || '65'
    @datasource_params = {start: start, rows: rows, wt: 'json'}
    @rsp_field = 'response'
    @each_rec_field = 'docs'
    #@authentication = [user,password]
    @set_data_map = set_map_nyu_press
    super
  end

  private

  def set_map_nyu_press
   {
      identifier: ['id'],
      isbn: ['id'],
      title: ['title'],
      available: ['handle'],
      citation: ['handle'],
      date: ['date'],
      description: ['description'],
      type: FORMAT,
      language: ['language'],
      format: FORMAT
    }
 end


end
