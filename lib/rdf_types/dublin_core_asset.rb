class DublinCoreAsset
  include ActiveFedora::RdfObject 
  map_predicates do |map|
    map.title(in: RDF::DC)
    map.creator(in: RDF::DC)
    map.contributor(in: RDF::DC)
    map.date(in: RDF::DC)
    map.subject(in: RDF::DC)
    map.relation(in: RDF::DC)
  end
end