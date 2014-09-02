class Nyucore < ActiveFedora::Base
  class Metadatum < String

    attr_reader :datastream

    def initialize(value, datastream)
      super(value)
      unless datastream.is_a? NyucoreRdfDatastream
        raise ArgumentError.new("Expecting #{datastream} to be an NyucoreRdfDatastream")
      end
      @datastream = datastream
    end

    def source?
      datastream.dsid == 'source_metadata'
    end
  end
end
