module Ichabod
  class NyucoreDatastream < ActiveFedora::NtriplesRDFDatastream
    TERMS = {
      RDF::DC => [:identifier, :title, :creator, :contributor, :publisher,
        :type, :description, :date, :format, :language, :relation, :rights,
        :subject],
      NyucoreMetadata::Vocabulary => [:available, :edition, :series, :version,
        :citation],
      Ichabod::Vocabulary => [:addinfolink, :addinfotext, :resource_set]
    }
    FACETABLE_TERMS = [:creator, :type, :language, :subject]

    map_predicates do |map|
      TERMS.each_pair do |vocabulary, terms|
        terms.each do |term|
          index_args = [:stored_searchable]
          index_args << :facetable if FACETABLE_TERMS.include? term
          # Send publicly since :format is defined privately
          map.public_send(term, in: vocabulary) do |index|
            index.as(*index_args)
          end
        end
      end
    end
  end
end
