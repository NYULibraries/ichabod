module RDF
  require 'nyucore'
  class DCTERMS < RDF::Vocabulary("http://dublincore.org/documents/dcmi-terms")
    NyuCore::Field::DCTERMS_NAMES.each do |name|
      property name
    end
  end
end
