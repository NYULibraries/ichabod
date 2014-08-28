class Nyucore < ActiveFedora::Base
  include Hydra::AccessControls::Permissions

  FIELDS = {
    :multiple => [:available, :citation, :title, :creator, :type, :publisher,
                  :description, :edition, :date, :format, :language, :relation,
                  :rights, :subject, :series, :version],
    :single => [:identifier]
  }
  EXTRAS = [:addinfolink, :addinfotext]
  METADATA_STREAMS = ['source_metadata', 'native_metadata']

  # Add multiple metadata streams to the model and include the attributes we
  # want on each stream. AcitveFedora::Base.has_attributes sets the attribute
  # readers and writers, which we explictly override below, but this gives us
  # our base.
  METADATA_STREAMS.each do |metadata_stream|
    has_metadata metadata_stream, type: NyucoreRdfDatastream
    has_attributes *FIELDS[:single], datastream: metadata_stream, multiple: false
    has_attributes *FIELDS[:multiple], datastream: metadata_stream, multiple: true
    has_attributes *EXTRAS, datastream: metadata_stream, multiple: true
  end

  # Override the attribute writers by delegating to the native_metadata
  # datastream. While this actually happens by default since the native_metadata
  # element is the last one in the METADATA_STREAMS Array and
  # ActiveFedora::Base.has_attributes defines the attribute writer method for the
  # the model, we don't want to depend on the order, since it could change.
  #
  # Examples
  #   pid = 'prefix:pid'
  #   nyucore = Nyucore.new(pid: pid)
  #   # => <Nyucore>
  #   nyucore.title= 'Native Title'
  #   # => nil
  #   nyucore.title
  #   # => ['Native Title']
  #   nyucore.source_metadata.title = 'Source Title'
  #   # => nil
  #   nyucore.title
  #   # => ['Source Title', 'Native Title']
  extend Forwardable
  (FIELDS[:single] + FIELDS[:multiple] + EXTRAS).each do |field|
    def_delegators :native_metadata, "#{field}=".to_sym
  end

  # Override the attribute readers to return both source AND native metadata
  # values for attribute with multiple values
  #
  # Examples
  #   pid = 'prefix:pid'
  #   nyucore = Nyucore.new(pid: pid)
  #   # => <Nyucore>
  #   nyucore.title= 'Native Title'
  #   # => nil
  #   nyucore.title
  #   # => ['Native Title']
  #   nyucore.source_metadata.title = 'Source Title'
  #   # => nil
  #   nyucore.title
  #   # => ['Source Title', 'Native Title']
  (FIELDS[:multiple] + EXTRAS).each do |field|
    define_method(field) do
      source_metadata.send(field) + native_metadata.send(field)
    end
  end

  # Override the attribute readers to return source metadata OR native metadata
  # values for attributes with single values
  # Examples
  #   pid = 'prefix:pid'
  #   nyucore = Nyucore.new(pid: pid)
  #   # => <Nyucore>
  #   nyucore.identifier= 'native_identifier'
  #   # => nil
  #   nyucore.identifier
  #   # => 'native_identifier'
  #   nyucore.source_metadata.identifier = 'source_identifier'
  #   # => nil
  #   nyucore.identifier
  #   # => 'source_identifier'
  FIELDS[:single].each do |field|
    define_method(field) do
      value ||= begin
        if source_metadata.send(field).present?
          source_metadata.send(field)
        else
          native_metadata.send(field)
        end
      end
      # ActiveFedora forces the first value and so do we.
      # https://github.com/projecthydra/active_fedora/blob/v6.7.6/lib/active_fedora/attributes.rb#L153
      value.first
    end
  end

  ##
  # Refine data before saving into solr
  def to_solr solr_doc = Hash.new
    super(solr_doc)
    Solrizer.insert_field(solr_doc, "collection", collections, :facetable, :displayable)
  end

  def collections
    @collections ||= Collections.new(self)
  end
end
