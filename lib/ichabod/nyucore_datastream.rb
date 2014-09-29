module Ichabod
  class NyucoreDatastream < ActiveFedora::NtriplesRDFDatastream
    TERMS = {
      RDF::DC => [:identifier, :title, :creator, :contributor, :publisher,
        :type, :description, :date, :format, :language, :relation, :rights,
        :subject],
      NyucoreMetadata::Vocabulary => NyucoreMetadata::Vocabulary::TERMS,
      Ichabod::Vocabulary => Ichabod::Vocabulary::TERMS
    }
    FACETABLE_TERMS = [:creator, :type, :language, :subject]

    ##
    # For active_fedora 7.x properties are now mapped like this
    #
    # Ex.
    # => property :subject, predicate: RDF::DC.subject
    TERMS.each_pair do |vocabulary, terms|
      terms.each do |term|
        index_args = [:stored_searchable]
        index_args << :facetable if FACETABLE_TERMS.include? term
        property term, predicate: vocabulary.send(term) do |index|
          index.as(*index_args)
        end
      end
    end

    # Overriding rdf_datastream.rb's prefix method allows us to
    # force all the metadata, irrespective of it's datastream,
    # into the same solr fields
    # Though, as Joe pointed out, we could want to revisit this decision
    # to allow different weighting for different datastreams.
    def prefix(name)
      name = name.to_s unless name.is_a? String
      pre = "desc_metadata"
      "#{pre}__#{name}".to_sym
    end
  end
end
