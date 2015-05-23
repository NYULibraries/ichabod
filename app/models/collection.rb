class Collection < ActiveFedora::Base
   include Hydra::AccessControls::Permissions

  COLLECTION_FIELDS = {
    :multiple => [ :creator,  :publisher ],
    :single => [ :title, :description, :rights, ],
    :workflow => [ :discoverable ]
  }
  SINGLE_FIELDS = COLLECTION_FIELDS[:single]
  MULTIPLE_FIELDS = COLLECTION_FIELDS[:multiple]
  WORKFLOW_FIELDS = COLLECTION_FIELDS[:workflow]

  validates :title, presence: true

  metadata_stream = 'collection_metadata'
  workflow_stream = 'workflow_metadata'

    has_metadata metadata_stream, type: Ichabod::NyucoreDatastream
    has_metadata workflow_stream, type: Ichabod::NyucoreDatastream
    has_attributes(*SINGLE_FIELDS, datastream: metadata_stream, multiple: false)
    has_attributes(*MULTIPLE_FIELDS, datastream: metadata_stream, multiple: true)
    has_attributes(*WORKFLOW_FIELDS, datastream: workflow_stream, multiple: false)
    
end
