# ResourceSets

## Ichabod::ResourceSet::Base
Ichabod::ResourceSets are a logical group of Ichabod::ResourceSet::Resources.
They are [Enumerable](http://ruby-doc.org/core/Enumerable.html) and iterate
over the set of Resources. They can read from source, persist to Fedora and
delete from Fedora.

## Ichabod::ResourceSet::Resource
Resources are intermediary objects that respond to the instance method
`#to_nyucore` in order to coerce themselves to an Nyucore object.
They do not persist themselves when coercing themselves, since that seems
presumptuous.

## Ichabod::ResourceSet::SourceReader
SourceReaders read from the ResourceSet's source system and retrieve an Array of
ResourceSet::Resources that are passed back to the ResourceSet

## Examples

```ruby
# resource_sets/spatial_data_repository.rb
class SpatialDataRepository < Ichabod::ResourceSet::Base
  self.prefix = 'sdr'
  self.source_reader = :oai_dc_file_reader
  editor :gis_cataloger
  editor :editor1, :editor2
  before_create :add_additional_info_link

  def add_additional_info_link(nyucore)
    nyucore.addinfolink = 'http://nyu.libguides.com/content.php?pid=169769&sid=1489817'
    nyucore.addinfotext = 'GIS Dataset Instructions'
  end
end

# At initialization, a ResourceSet can given options for the instance
instance_options = {option_key: 'options value'}

# Create a new SpatialDataRepository ResourceSet with the given options
spatial_data_repository = SpatialDataRepository.new(instance_options)

# See the properties
spatial_data_repository.prefix
# => "sdr"
spatial_data_repository.source_reader
# => Ichabod::ResourceSet::SourceReaders::OaiDcFileReader
spatial_data_repository.editors
# => ['admin_group', 'gis_cataloger', 'editor1', 'editor2']
spatial_data_repository.before_creates
# => [:add_edit_groups, :add_additional_info_link]
spatial_data_repository.option_key
# => "options value"

# To get the set of Resources for the instance from the source, we can call the
# #read_from_source method. Reading from source instantiates the specified
# Ichabod::ResourceSet::SourceReader, passing in the current instance of the
# ResourceSet to the SourceReader's constructor (if it hasn't already been
# instantiated), and calls SourceReader#read to retrieve the set of Resources
# from the source
spatial_data_respository.read_from_source
# => Array of Resources, read from the source

# ResourceSets are Enumerable and iterate over the set of Resources
spatial_data_repository.each do |resource|
  p resource.class.name
end
# => Prints "Ichabod::ResourceSet::Resource" N times

# Both #size and #count return the number of Resources in the set
spatial_data_repository.size
# => N

# Persist Nyucore objects to the Fedora repository and index them in Solr
spatial_data_repository.create
# => Reads from source (if not already read) and creates the Resources in Fedora
#    as Nyucore objects and indexes them in Solr. Returns an Array of the
#    created Nyucore objects.

# Delete Nyucore object from the Fedora repository
# and delete them from the Solr index
spatial_data_repository.delete
# => Deletes the Nyucore objects from Fedora, deletes them from the Solr index
#    and clears them from the ResourceSet.  Returns an Array of the deleted
#    Nyucore object.
```
