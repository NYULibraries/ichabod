class Collection < ActiveFedora::Base
  include Hydra::AccessControls::Permissions
  include Hydra::Validations

  has_many :nyucores, :property=>:is_part_of, :dependent=> :restrict

  DESCRIPTIVE_FIELDS = {
    :multiple => [ :creator, :publisher ],
    :single => [ :title, :description, :rights, :identifier ],
  }

  ADMIN_FIELDS = [ :discoverable ]
  SINGLE_FIELDS = DESCRIPTIVE_FIELDS[ :single ] + ADMIN_FIELDS
  MULTIPLE_FIELDS = DESCRIPTIVE_FIELDS[ :multiple ]
  FIELDS=SINGLE_FIELDS+MULTIPLE_FIELDS+ ADMIN_FIELDS
  REQUIRED_FIELDS = [ :title, :discoverable ]
  ID_PREFIX="ichabodcollection"

  validates :title, presence: true
  #validates :title, uniqueness: { solr_name: "desc_metadata__title_tesim" }
  validates :discoverable, presence: true

  descriptive_metadata = 'descriptive_metadata'
  administrative_metadata = 'administrative_metadata'

  def self.assign_pid(_)
    "#{ID_PREFIX}:#{SecureRandom.uuid}"
  end

  def self.private_collections
    where( :administrative_metadata__discoverable_tesim=>'0' )
  end

  has_metadata descriptive_metadata, type: Ichabod::NyucoreDatastream
  has_attributes(*DESCRIPTIVE_FIELDS[:single], datastream: descriptive_metadata , multiple: false)
  has_attributes(*MULTIPLE_FIELDS, datastream: descriptive_metadata , multiple: true)
  has_metadata administrative_metadata, type: Ichabod::AdministrativeDatastream
  has_attributes(*ADMIN_FIELDS, datastream: administrative_metadata, multiple: false)

end
