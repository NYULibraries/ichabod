class SolrDocumentUrlFieldsDecorator 
  

  def initialize(solr_document, field, blacklight_config)
  	@solr_document = solr_document
  	@field = field
  	@blacklight_config = blacklight_config
  end

  def test
    value = @solr_document[@field]
    link_text_field = blacklight_config.show_fields[@field.to_s][:text]

    return @solr_document[@field]
  end
  def urls
  	#refactor to allow for multiple and single url processing
  	#get a static solr document for rspec testing - multiple urls and single urls
  	#contact Barnaby
  	@urls ||= begin
  		value = @solr_document[@field]
      link_text_field = blacklight_config.show_fields[@field.to_s][:text]
      if value.length > 1
        value.each_index do |index|
          urls << Url.new(value[index], @solr_document[link_text_field][index])
        end
      else
        text      = @solr_document.get(link_text_field)
        url       = @solr_document.get(@field)
        metadata_type = @solr_document["desc_metadata__type_tesim"] 
        text = "Download" if metadata_type[0] == "Geospatial Data"
        link_text = text.nil? ? url : text
      
        urls << Url.new(url,text)
      end

  	rescue Exception => e
  		
  	end
  end

  private
  def make_url
  end

  
    class Url
    	attr_reader :value, :text

    	def initialize(value, text=nil)
    		@value = value
    		@text = (text || value)
    	end


    	def to_s
    		value
    	end
    end

end
