class TestJsonData < Ichabod::ResourceSet::Base
  self.prefix = 'test'
  self.source_reader = :json_loader
  FORMAT = "Book"

  attr_reader :endpoint_url, :datasource_params, :authentication, :rsp_field, :each_rec_field, :set_data_map
  
  def initialize(*args)

    @endpoint_url = args.shift
    user = args.shift
    password = args.shift
    start = args.shift || '0'
    rows = args.shift || '65'
    @datasource_params = {start: start, rows: rows, wt: 'json'}
    @rsp_field = 'response'
    @each_rec_field = 'docs'
    #@authentication = [user,password]
    @set_data_map = set_map_masses
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
 
 def field_hsh(field)
  { field1: field}
 end
 
 def mini_hsh(field)
  {'metadata' => [field,'value']}
 end
 def set_map_masses
   {
      identifier: ['identifier'],
      title: {field1: 'entity_title', delim1: ' ', field2: mini_hsh('description'), join: ', '}
      available: mini_hsh('handle'),
      citation: mini_hsh('handle'),
      date: mini_hsh('publication_date'),
      description: mini_hsh('description'),
      subject: mini_hsh('subject'),
      creator: mini_hsh('editor'),
      language:  mini_hsh('language'),
      type: FORMAT.capitalize,
      format: FORMAT.capitalize
    }
 end

end
