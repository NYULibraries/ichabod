class Nyucore < ActiveFedora::Base
  class Metadatum < String

    attr_reader :datastream, :index

    def initialize(value, datastream, index=0)
      super(value)
      unless datastream.is_a? Ichabod::NyucoreDatastream
        raise ArgumentError.new("Expecting #{datastream} to be an Ichabod::NyucoreDatastream")
      end
      @datastream = datastream
      @index = index
    end

    def source?
      datastream.dsid == 'source_metadata'
    end
  end
end
