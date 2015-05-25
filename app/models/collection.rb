class Collection < ActiveFedora::Base
   include Hydra::AccessControls::Permissions
    require 'active_fedora/noid'
    
  COLLECTION_FIELDS = {
    :multiple => [ :creator, :publisher ],
    :single => [ :title, :description, :rights ],
  }
  WORKFLOW_FIELDS = [ :discoverable ]
  SINGLE_FIELDS = COLLECTION_FIELDS[ :single ] + WORKFLOW_FIELDS
  MULTIPLE_FIELDS = COLLECTION_FIELDS[ :multiple ]
  FIELDS=SINGLE_FIELDS+MULTIPLE_FIELDS+ WORKFLOW_FIELDS
  REQUIRED_FIELDS = [ :title, :discoverable ]

  validates :title, presence: true
  validates :discoverable, presence: true

  metadata_stream = 'collection_metadata'
  workflow_stream = 'workflow_metadata'

  def self.assign_pid(_)
    noid_service ||= ActiveFedora::Noid::Service.new
   "ichabod_collection:#{noid_service.mint}"
  end
   

    has_metadata metadata_stream, type: Ichabod::NyucoreDatastream
    has_attributes(*SINGLE_FIELDS, datastream: metadata_stream, multiple: false)
    has_attributes(*MULTIPLE_FIELDS, datastream: metadata_stream, multiple: true)
    
    has_metadata workflow_stream, type: Ichabod::WorkflowDatastream
    has_attributes(*WORKFLOW_FIELDS, datastream: workflow_stream, multiple: false)

    
end
