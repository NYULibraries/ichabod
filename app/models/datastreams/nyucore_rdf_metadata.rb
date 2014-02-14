require './lib/rdf/nyu'
require './lib/rdf/dcterms'
class NyucoreRdfMetadata < ActiveFedora::NtriplesRDFDatastream
  # Specify the "facetable" predicates
  FACETABLE_PREDICATES = [:creator, :type, :language, :subject]
  # Map the predicates
  map_predicates do |map|
    index_options = [:stored_searchable]
    NyuCore::Field::VALID_NAMES.each do |predicate|
      index_options << :facetable if FACETABLE_PREDICATES.include?(predicate)
      rdf_vocabulary = case predicate
        when *NyuCore::Field::DC_NAMES
          RDF::DC
        when *NyuCore::Field::DCTERMS_NAMES
          RDF::DCTERMS
        when *NyuCore::Field::NYU_NAMES
          RDF::NYU
        end
      map.public_send(predicate, in: rdf_vocabulary) do |index|
        index.as *index_options
      end
    end
  end
end
