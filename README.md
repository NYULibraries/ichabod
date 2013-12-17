# Hydra NYU

Hydra components – Fedora, Solr, Blacklight

In Fedora an object can have many 'datastreams' which are either content for the object or metadata about the object.

ActiveFedora with OM allow you to describe your Fedora objects when indexing into Solr

OM describes format of an xml doc in Ruby (Tame your XML with OM)

Demo version comes packaged with a Solr and Fedora

One of the main features that Hydra adds to Blacklight is the ability to control who has access to which information in search results.

-	Defining additional metadata
-	Defining access controls per object
-	Defining relationships between objects (the Fedora RDF is translated to active record like database relations)

Datastreams can hold metadata about objects or content (i.e. book cover image, pdf of actual book page)

Access privileges – 
- Default: Discover, Read, Edit
- Custom
- Can be granted at the user or group level

