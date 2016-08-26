class VinopalFdaCollection < Ichabod::ResourceSet::Base
  self.prefix = 'fda'
  self.source_reader = :fda_collection_rest_reader
  self.collection_title = "Jennifer Vinopal Collection"
  editor :fda_cataloger


  attr_reader :fda_collection_id, :fda_rest_url, :fda_rest_user, :fda_rest_pass
  alias_method :collection_code, :prefix

  def initialize(*args)
    @fda_collection_id = '520'
    @fda_rest_url = args.shift
    @fda_rest_user = args.shift
    @fda_rest_pass = args.shift
    super
  end

end
