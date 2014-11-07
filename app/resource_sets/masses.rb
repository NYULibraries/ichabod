class Masses < Ichabod::ResourceSet::Base
  self.prefix = 'masses'
  self.source_reader = :masses_reader

  attr_reader :endpoint_url, :resource_format, :resource_type, :start, :rows 
  alias_method :collection_code, :prefix

  def initialize(*args)
    @endpoint_url = args.shift
    @resource_format = "Book"
    @resource_type = "Book"
    
    start = args.shift
    rows = args.shift

    if is_numeric?(start)
      @start = start
    else      
      @start = 0
    end
    
    if is_numeric?(rows)
      @rows = rows
    else      
      @rows = 10
    end

    super
  end
  
  private 
  
  def is_numeric?(s)
    !!Float(s) rescue false
  end  

end