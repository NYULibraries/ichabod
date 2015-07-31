module Ichabod
  class Vocabulary < RDF::Vocabulary
    URI = 'http://library.nyu.edu/data/ichabod#'

    TERMS = [:addinfolink, :addinfotext, :resource_set, :discoverable, :isbn]

    TERMS.each { |term| property term }
    def initialize
      super(URI)
    end
  end
end
