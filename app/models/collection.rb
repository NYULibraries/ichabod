class Collection < ActiveFedora::NtriplesRDFDatastream

    TERMS = {
      RDF::DC => [:identifier, :title, :creator, :publisher,
        :description, :rights],

      NyucoreMetadata::Vocabulary => [:available]

    }

   TERMS.each_pair do |vocabulary, terms|
      terms.each do |term|
        property term, predicate: vocabulary.send(term) do |index|
          index.as(*index_args)
        end
      end
    end

end
