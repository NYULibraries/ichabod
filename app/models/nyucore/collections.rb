class Nyucore < ActiveFedora::Base
  class Collections
    include Enumerable

    COLLECTION_MAP = { "ESRI" => { publisher: ["ESRI"] }, "Spatial Data Repository" => { type: ["Geospatial Data"] } }

    attr_reader :nyucore

    def initialize(nyucore)
      unless nyucore.is_a?(Nyucore)
        raise ArgumentError.new("Expecting an instance of Nyucore, but was #{nyucore.class}")
      end
      @nyucore = nyucore
    end

    def each(&block)
      collections.each(&block)
    end

  private

    ##
    # Get array of collections from mapping
    def collections
      @collections = map_to_collection(:publisher)
      @collections |= map_to_collection(:type)
      @collections.reject {|c| c.nil?}
    end

    ##
    # Map values in from_field to the collection value held in the constant
    # Ex:
    # Given an object <Nyucore type: ["Geospatial Data","Blahblah"]>
    # map_to_collection(:type) # ["Spatial Data Repository"]
    def map_to_collection(from_field)
      # Return a new hash from the collection map
      # where this object has a value in from_field that matches
      # one of the values in COLLECTION_MAP
      map_to_collection = COLLECTION_MAP.select {|c| COLLECTION_MAP[c][from_field].present? && COLLECTION_MAP[c][from_field].any? {|ff| nyucore.send(from_field).include? ff }}
      map_to_collection.keys
    end
  end
end
