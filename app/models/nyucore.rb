class Nyucore < ActiveFedora::Base
  include Hydra::AccessControls::Permissions

  NYUCORE_FIELDS = {
    :multiple => [:available, :citation, :title, :creator, :type, :publisher,
                  :description, :edition, :date, :format, :language, :relation,
                  :rights, :subject, :series, :version],
    :single => [:identifier]
  }
  EXTRA_SINGLES = [:resource_set]
  EXTRA_MULTIPLES = [:addinfolink, :addinfotext]
  SINGLE_FIELDS = NYUCORE_FIELDS[:single] + EXTRA_SINGLES
  MULTIPLE_FIELDS = NYUCORE_FIELDS[:multiple] + EXTRA_MULTIPLES
  FIELDS = SINGLE_FIELDS + MULTIPLE_FIELDS
  METADATA_STREAMS = ['source_metadata', 'native_metadata']

  # Add multiple metadata streams to the model and include the attributes we
  # want on each stream. AcitveFedora::Base.has_attributes sets the attribute
  # readers and writers, which we explictly override below, but this gives us
  # our base.
  METADATA_STREAMS.each do |metadata_stream|
    has_metadata metadata_stream, type: Ichabod::NyucoreDatastream
    has_attributes(*SINGLE_FIELDS, datastream: metadata_stream, multiple: false)
    has_attributes(*MULTIPLE_FIELDS, datastream: metadata_stream, multiple: true)
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
  FIELDS.each do |field|
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
  MULTIPLE_FIELDS.each do |field|
    define_method(field) do
      source_metadata.send(field).each_with_index.collect do |value, index|
        Metadatum.new(value, source_metadata, index)
      end + native_metadata.send(field).each_with_index.collect do |value, index|
        Metadatum.new(value, native_metadata, index)
      end
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
  SINGLE_FIELDS.each do |field|
    define_method(field) do
      # ActiveFedora forces the first value and so do we.
      # https://github.com/projecthydra/active_fedora/blob/v7.0.0/lib/active_fedora/attributes.rb#L134
      if source_metadata.send(field).present?
        Metadatum.new(source_metadata.send(field).first, source_metadata)
      elsif native_metadata.send(field).present?
        Metadatum.new(native_metadata.send(field).first, native_metadata)
      end
    end
  end

  ##
  # Refine data before saving into solr
  def to_solr(solr_doc = {})
    # to_solr super is no longer passing a reference to one big solr document
    # so reference solr_doc locally (Hydra 7.0.0)
    solr_doc = super(solr_doc)
    Solrizer.insert_field(solr_doc, "collection", collections, :facetable, :displayable)
    solr_doc
  end

  def collections
    @collections ||= Collections.new(self)
  end
end
