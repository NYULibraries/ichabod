module Ichabod
  class AdminisrativeDatastream < ActiveFedora::NtriplesRDFDatastream

    TERMS = {
      Ichabod::Vocabulary => [ :discoverable ]
    }

    ##
    # For active_fedora 7.x properties are now mapped like this
    #
    # Ex.
    # => property :subject, predicate: RDF::DC.subject
    TERMS.each_pair do |vocabulary, terms|
      terms.each do |term|
        index_args = [:stored_searchable]
        property term, predicate: vocabulary.send(term) do |index|
          index.as(*index_args)
        end
      end
    end
  end
end
