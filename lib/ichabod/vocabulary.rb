module Ichabod
  class Vocabulary < RDF::Vocabulary
  	include MetadataFields
    source_info = MetadataFields.get_source_info(ns:'ichabod')
    NAMESPACE = source_info[:namespace]
    URI = source_info[:uri]
    TERMS = MetadataFields.process_metadata_field_names(ns:'ichabod')
    TERMS.each { |term| property term }
    def initialize
      super(URI)
    end
  end
end
