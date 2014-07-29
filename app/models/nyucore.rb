class Nyucore < ActiveFedora::Base
  field_list = [:identifier, :addinfolink, :addinfotext, :available, :citation, :title, :creator,
                :type, :publisher, :description, :edition, :date, :format, :language,
                :relation, :rights, :subject, :series, :version]

  has_metadata 'descMetadata', type: NyucoreRdfDatastream

  has_attributes *field_list, datastream: 'descMetadata', multiple: true

  ##
  # Refine data before saving into solr
  def to_solr solr_doc = Hash.new
    super(solr_doc)
    Solrizer.insert_field(solr_doc, "collection", collections, :facetable, :displayable)
  end

  ##
  # Get array of collections from publisher and type mapping
  def collections
    collections = []
    collections << map_to_collection(self.publisher)
    collections << map_to_collection(self.type)
    return collections.flatten.reject {|c| c.nil?}
  end

  ##
  # Map type name to the collection value in config
  def map_to_collection(from_field)
    (from_field.is_a? Array) ? from_field.map {|t| collection_map[t]} : collection_map[from_field]
  end

  def collection_map
    @collection_map ||= YAML::load_file(Rails.root.join('config', "collection_map.yml"))
  end
  private :collection_map

end
