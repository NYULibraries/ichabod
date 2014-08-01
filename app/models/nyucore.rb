class Nyucore < ActiveFedora::Base
  FIELD_LIST = {
    :multiple => [:addinfolink, :addinfotext, :available, :citation, :title, :creator,
                  :type, :publisher, :description, :edition, :date, :format, :language,
                  :relation, :rights, :subject, :series, :version],
    :single => [:identifier]
  }

  has_metadata 'descMetadata', type: NyucoreRdfDatastream

  has_attributes *FIELD_LIST[:single], datastream: 'descMetadata', multiple: false
  has_attributes *FIELD_LIST[:multiple], datastream: 'descMetadata', multiple: true

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
