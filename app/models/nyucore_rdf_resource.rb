require 'nyucore'
class NyuCoreRdfResource < ActiveFedora::Base
  SINGLES = [:title, :creator, :publisher, :identifier, :type]
  has_metadata 'descMetadata', type: NyucoreRdfMetadata
  NyuCore::Fields::VALID_NAMES.each do |attribute|
    multiple = SINGLES.include?(attribute) ? false : true
    has_attributes attribute, datastream: 'descMetadata', multiple: multiple
  end
end
