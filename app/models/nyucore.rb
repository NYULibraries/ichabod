class Nyucore < ActiveFedora::Base
    has_metadata 'descMetadata', type: NyucoreRdfDatastream

    has_attributes :title, datastream: 'descMetadata', multiple: false
    has_attributes :creator, datastream: 'descMetadata', multiple: false
    has_attributes :publisher, datastream: 'descMetadata', multiple: false
    has_attributes :identifier, datastream: 'descMetadata', multiple: false
    has_attributes :available, datastream: 'descMetadata', multiple: true
    has_attributes :type, datastream: 'descMetadata', multiple: false
    has_attributes :description, datastream: 'descMetadata', multiple: true
    has_attributes :edition, datastream: 'descMetadata', multiple: true
    has_attributes :series, datastream: 'descMetadata', multiple: true
    has_attributes :version, datastream: 'descMetadata', multiple: true
    # Adds for FDA Work below
    has_attributes :date, datastream: 'descMetadata', multiple: true
    has_attributes :format, datastream: 'descMetadata', multiple: true
    has_attributes :language, datastream: 'descMetadata', multiple: true
    has_attributes :relation, datastream: 'descMetadata', multiple: true
    has_attributes :rights, datastream: 'descMetadata', multiple: true
    has_attributes :subject, datastream: 'descMetadata', multiple: true
    has_attributes :citation, datastream: 'descMetadata', multiple: true
end