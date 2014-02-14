module RDF
  require 'nyucore'
  class NYU < RDF::Vocabulary("https://library.nyu.edu/nyucore#")
    NyuCore::Field::NYU_NAMES.each do |name|
      property name
    end
  end
end
