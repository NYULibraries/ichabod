module NyucoreMetadata
  class Vocabulary < RDF::Vocabulary
    #URI = 'http://harper.bobst.nyu.edu/data/nyucore#'
    #TERMS = [:available, :edition, :series, :version, :citation, :restrictions]
    source_info = MetadataFields.get_source_info(ns:'nyucore')
    NAMESPACE = source_info[:namespace]
    URI = source_info[:uri]
    TERMS = MetadataFields.process_metadata_field_names(ns:'nyucore')
    TERMS.each { |term| property term }

    def initialize
      super(URI)
    end
  end
end
