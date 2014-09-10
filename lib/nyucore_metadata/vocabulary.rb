module NyucoreMetadata
  class Vocabulary < RDF::Vocabulary
    URI = 'http://harper.bobst.nyu.edu/data/nyucore#'
    TERMS = [:available, :edition, :series, :version, :citation]

    TERMS.each { |term| property term }

    def initialize
      super(URI)
    end
  end
end
