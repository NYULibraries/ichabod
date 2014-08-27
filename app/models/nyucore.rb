class Nyucore < ActiveFedora::Base
  include Hydra::AccessControls::Permissions

  FIELDS = {
    :multiple => [:available, :citation, :title, :creator, :type, :publisher,
                  :description, :edition, :date, :format, :language, :relation,
                  :rights, :subject, :series, :version],
    :single => [:identifier]
  }

  EXTRAS = [:addinfolink, :addinfotext]

  # Delegate writers for attributes to the native_metadata datastream.
  # This happens by default since the native_metadata element is the last one
  # in the Array and ActiveFedora sets it as the writer for the attribute on the
  # model
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
  METADATA_STREAMS = ['source_metadata', 'native_metadata']
  METADATA_STREAMS.each do |metadata_stream|
    has_metadata metadata_stream, type: NyucoreRdfDatastream
    has_attributes *FIELDS[:single], datastream: metadata_stream, multiple: false
    has_attributes *FIELDS[:multiple], datastream: metadata_stream, multiple: true
    has_attributes *EXTRAS, datastream: metadata_stream, multiple: true
  end

  attr_accessible = *FIELD_LIST[:single], *FIELD_LIST[:multiple]
  
  FIELD_LIST[:multiple].concat(FIELD_LIST[:single]).each do |attr_name|
    puts #{attr_name}
    define_method("#{attr_name}=") do |argument|
      #puts "#{attr_name}|" + argument
      #@nyucore.source_metadata.send("#{attribute}=".to_sym, send(attribute))
      #"performing #{action.gsub('_', ' ')} on #{argument}"
#binding.pry
      self.native_metadata.send("#{attr_name}=", argument)
    end
  end

  #def title=(value)
  #  #self.native_metadata.title.concat(value)
  #  self.native_metadata.title = value
  #end

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
