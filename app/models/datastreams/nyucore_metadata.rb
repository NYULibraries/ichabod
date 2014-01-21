class NyucoreMetadata < ActiveFedora::OmDatastream

  set_terminology do |t|
    t.root(path: "fields")
    t.title(index_as: :stored_searchable)
    t.author(index_as: :stored_searchable)
    t.publisher(index_as: :stored_searchable)
    t.identifier(index_as: :stored_searchable)
    t.available(index_as: :stored_searchable)
    t.type(index_as: :stored_searchable)
    t.description(index_as: :stored_searchable)
    t.edition(index_as: :stored_searchable)
    t.series(index_as: :stored_searchable)
    t.version(index_as: :stored_searchable)
    # Adds for FDA Below: 
    t.date(index_as: :stored_searchable)
    t.format(index_as: :stored_searchable)
    t.language(index_as: :stored_searchable)
    t.relation(index_as: :stored_searchable)
    t.rights(index_as: :stored_searchable)
    t.subject(index_as: :stored_searchable)
    t.citation(index_as: :stored_searchable)

  end

  def self.xml_template
    Nokogiri::XML.parse("<fields/>")
  end
end