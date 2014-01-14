class Nyucore < ActiveFedora::Base
  has_metadata 'descMetadata', type: NyucoreMetadata

  has_attributes :title, datastream: 'descMetadata', multiple: false
  has_attributes :author, datastream: 'descMetadata', multiple: false
  has_attributes :publisher, datastream: 'descMetadata', multiple: false
  has_attributes :identifier, datastream: 'descMetadata', multiple: false
  has_attributes :available, datastream: 'descMetadata', multiple: true
  has_attributes :type, datastream: 'descMetadata', multiple: false
  has_attributes :description, datastream: 'descMetadata', multiple: true
  has_attributes :edition, datastream: 'descMetadata', multiple: true
  has_attributes :series, datastream: 'descMetadata', multiple: true
  has_attributes :version, datastream: 'descMetadata', multiple: true

end