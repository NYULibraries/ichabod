class NyuTerms < RDF::Vocabulary("http://harper.bobst.nyu.edu/data/nyucore#")
  property :available
  property :edition
  property :series
  property :version
  property :citation
  property :addinfolink
  property :addinfotext
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
    map.addinfolink(in: NyuTerms) do |index|
      index.as :stored_searchable
    end
    map.addinfotext(in: NyuTerms) do |index|
      index.as :stored_searchable
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
    return "#{pre}__#{name}".to_sym
  end
end