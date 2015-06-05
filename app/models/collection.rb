class Collection < ActiveFedora::Base
   include Hydra::AccessControls::Permissions
   require 'active_fedora/noid'
  
  DESCRIPTIVE_FIELDS = {
    :multiple => [ :creator, :publisher ],
    :single => [ :title, :description, :rights, :identifier ],
  }

  ADMIN_FIELDS = [ :discoverable ]
  SINGLE_FIELDS = DESCRIPTIVE_FIELDS[ :single ] + ADMIN_FIELDS
  MULTIPLE_FIELDS = DESCRIPTIVE_FIELDS[ :multiple ]
  FIELDS=SINGLE_FIELDS+MULTIPLE_FIELDS+ ADMIN_FIELDS
  REQUIRED_FIELDS = [ :title, :discoverable ]
  NOID_PREFIX="ichabod:collection"

  validates :title, presence: true
  validates :discoverable, presence: true

  descriptive_metadata = 'descriptive_metadata'
  administrative_metadata = 'administrative_metadata'

  def self.assign_pid(_)
   noid_service ||= ActiveFedora::Noid::Service.new
   "#{NOID_PREFIX}:#{noid_service.mint}"
  end
   

    has_metadata descriptive_metadata, type: Ichabod::NyucoreDatastream
    has_attributes(*SINGLE_FIELDS, datastream: descriptive_metadata , multiple: false)
    has_attributes(*MULTIPLE_FIELDS, datastream: descriptive_metadata , multiple: true)
    
    has_metadata administrative_metadata, type: Ichabod::AdministrativeDatastream
    has_attributes(*ADMIN_FIELDS, datastream: administrative_metadata, multiple: false)

    
end
