class Nyucore < ActiveFedora::Base
  include Hydra::AccessControls::Permissions
   include MdFields

 
  NYUCORE_FIELDS = {}
  NYUCORE_FIELDS[:single] = MdFields.process_md_fields(ns: 'nyucore', multiple: false)
  NYUCORE_FIELDS[:multiple] = MdFields.process_md_fields(ns:'nyucore', multiple: true)
  singles = []
  multiples = []
  # have to do this stupid hack
  # I don't think separate arrays 
  # for nyucore and extra fields
  # are needed 
  # Keeping it the way it is for now
  # until we discuss further
  # Because unraveling the tests 
  # will be onerous
  # Also to accomodate the tests
  # have to assign the variables to the constants
  # Should be changed to make it cleaner
  # when we determine test strategy
  sources = ['ichabod', 'dcterms']
  sources.each { |ns|
    singles += MdFields.process_md_fields(ns: ns, multiple: false)
    multiples += MdFields.process_md_fields(ns: ns, multiple: true)
  }

  EXTRA_SINGLES = singles
  EXTRA_MULTIPLES = multiples

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
    solr_doc = super(solr_doc)
    # Delete all the desc_metadata__ fields from the solr_doc so we can
    # readd them correctly
    solr_doc = solr_doc.delete_if {|field,value| field.to_s.start_with?("desc_metadata__") }
    datastreams.each_value do |ds|
      # Jumping through a few hoops here to make it work like it did in the below commit:
      # https://github.com/projecthydra/active_fedora/blob/889aa962a326ad9e8302ada3237193221ad2feb5/lib/active_fedora/indexing.rb
      solr_doc = ds.to_solr(solr_doc)
    end
    Solrizer.insert_field(solr_doc, "collection", collections, :facetable, :displayable)
    solr_doc
  end

  def collections
    @collections ||= Collections.new(self)
  end
=begin
  def assign_fields(field_array,multiple)
    MD_FIELDS.keys.each{ |source|
      MD_FIELDS[source].keys.each { |f|
        field_array.push(f) if MD_FIELDS[source][f][:multiple] == multiple
      }
    }
  end
=end
end
