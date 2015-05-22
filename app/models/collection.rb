class Collection < ActiveFedora::Base
   include Hydra::AccessControls::Permissions

  COLLECTION_FIELDS = {
    :multiple => [ :creator,  :publisher ],
    :single => [ :title, :description, :rights, :discoverable]

  }
  SINGLE_FIELDS = COLLECTION_FIELDS[:single]
  MULTIPLE_FIELDS = COLLECTION_FIELDS[:multiple]

  validates :title, presence: true

  metadata_stream = 'collection_metadata'

    has_metadata metadata_stream, type: Ichabod::NyucoreDatastream
    has_attributes(*SINGLE_FIELDS, datastream: metadata_stream, multiple: false)
    has_attributes(*MULTIPLE_FIELDS, datastream: metadata_stream, multiple: true)
    
end
