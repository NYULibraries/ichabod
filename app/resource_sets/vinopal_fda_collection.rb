class VinopalFdaCollection < Ichabod::ResourceSet::Base
  self.prefix = 'fda'
  self.source_reader = :fda_collection_rest_reader
  editor :fda_cataloger


  attr_reader :fda_collection_id
  alias_method :collection_code, :prefix

  def initialize(*args)
    @fda_collection_id = '520'
    super
  end

end
