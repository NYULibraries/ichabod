class Nyucore < ActiveFedora::Base
  include Hydra::AccessControls::Permissions

  FIELD_LIST = {
    :multiple => [:addinfolink, :addinfotext, :available, :citation, :title, :creator,
                  :type, :publisher, :description, :edition, :date, :format, :language,
                  :relation, :rights, :subject, :series, :version],
    :single => [:identifier]
  }

  has_metadata 'native_metadata', type: NyucoreRdfDatastream
  has_metadata 'source_metadata', type: NyucoreRdfDatastream

  has_attributes *FIELD_LIST[:single], datastream: 'native_metadata', multiple: false
  has_attributes *FIELD_LIST[:single], datastream: 'source_metadata', multiple: false
  has_attributes *FIELD_LIST[:multiple], datastream: 'native_metadata', multiple: true
  has_attributes *FIELD_LIST[:multiple], datastream: 'source_metadata', multiple: true

  attr_accessible = *FIELD_LIST[:single], *FIELD_LIST[:multiple]
  
  FIELD_LIST[:multiple].concat(FIELD_LIST[:single]).each do |attr_name|
    puts #{attr_name}
    define_method("#{attr_name}=") do |argument|
      #puts "#{attr_name}|" + argument
      #@nyucore.source_metadata.send("#{attribute}=".to_sym, send(attribute))
      #"performing #{action.gsub('_', ' ')} on #{argument}"
#binding.pry
      self.native_metadata.send("#{attr_name}=", argument)
    end
  end

  #def title=(value)
  #  #self.native_metadata.title.concat(value)
  #  self.native_metadata.title = value
  #end

  ##
  # Refine data before saving into solr
  def to_solr solr_doc = Hash.new
    super(solr_doc)
    Solrizer.insert_field(solr_doc, "collection", collections, :facetable, :displayable)
  end

  def collections
    @collections ||= Collections.new(self)
  end
end
