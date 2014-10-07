class Beard < Ichabod::ResourceSet::Base
  self.prefix = 'beard'
  #self.collection_code = self.prefix
  self.source_reader = :beard_reader

 
  alias_method :collection_code, :prefix

  def initialize
    super
  end
end
