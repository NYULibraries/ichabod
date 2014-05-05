class NyuTerms < RDF::Vocabulary("http://harper.bobst.nyu.edu/data/nyucore#")
  property :available
  property :edition
  property :series
  property :version
  property :citation
  property :addInfo
  property :addInfoUrl
  property :addInfoUrlText
end

class NyucoreRdfDatastream < ActiveFedora::NtriplesRDFDatastream
  map_predicates do |map|
    map.title(in: RDF::DC) do |index|
      index.as :stored_searchable
    end
    map.creator(in: RDF::DC) do |index|
      index.as :stored_searchable, :facetable
    end
    map.contributor(in: RDF::DC) do |index|
      index.as :stored_searchable
    end
    map.publisher(in: RDF::DC) do |index|
      index.as :stored_searchable
    end
    map.identifier(in: RDF::DC) do |index|
      index.as :stored_searchable
    end
    map.available(in: NyuTerms) do |index|
        index.as :stored_searchable
    end
    map.type(in: RDF::DC) do |index|
      index.as :stored_searchable, :facetable
    end
    map.description(in: RDF::DC) do |index|
      index.as :stored_searchable
    end
    map.edition(in: NyuTerms) do |index|
      index.as :stored_searchable
    end
    map.series(in: NyuTerms) do |index|
      index.as :stored_searchable
    end
    map.version(in: NyuTerms) do |index|
      index.as :stored_searchable
    end
    map.date(in: RDF::DC) do |index|
      index.as :stored_searchable
    end
    map.format(in: RDF::DC) do |index|
      index.as :stored_searchable
    end
    map.language(in: RDF::DC) do |index|
      index.as :stored_searchable, :facetable
    end
    map.relation(in: RDF::DC) do |index|
      index.as :stored_searchable    
    end
    map.rights(in: RDF::DC) do |index|
      index.as :stored_searchable
    end
    map.subject(in: RDF::DC) do |index|
      index.as :stored_searchable, :facetable
    end
    map.citation(in: NyuTerms) do |index|
      index.as :stored_searchable
    end
    map.addInfo(in: NyuTerms) do |index|
      index.as :stored_searchable
    end
    map.addInfoUrl(in: NyuTerms) do |index|
      index.as :stored_searchable
    end
    map.addInfoUrlText(in: NyuTerms) do |index|
      index.as :stored_searchable
    end
  end
end