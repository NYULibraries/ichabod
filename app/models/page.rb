class Page < ActiveFedora::Base
  
  has_metadata 'descMetadata', type: PageMetadata
  has_file_datastream "pageContent"

  belongs_to :book, :property => :is_part_of

  has_attributes :number, datastream: 'descMetadata', multiple: false
  has_attributes :text, datastream: 'descMetadata', multiple: false
  
end