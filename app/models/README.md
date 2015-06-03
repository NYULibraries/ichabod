# Nyucore and Ichabod Data Model(s)

## Nyucore

Nyucore is an element set, based primarily on Dublin Core with careful attention paid to [BobCat](http://bobcat.library.nyu.edu/) functionality, which is powered by Ex Libris' [Primo](http://www.exlibrisgroup.com/category/PrimoOverview). Nyucore is designed to be flexible and iterative, and fields are regularly added and refined according to the needs of collections added to Ichabod. Currently, Nyucore comprises 22 fields: 13 from the dc and dcterms namespaces, locally defined Nyucore terms, and 3 terms defined by Ichabod itself. 

#### Nyucore Fields

* identifier: not repeatable
* title
* creator: facetable
* contributor
* publisher
* type: facetable (as "Format")
* description
* date
* format
* language: facetable
* relation
* rights
* subject: facetable
* available
* edition
* series
* version
* citation
* restrictions: not repeatable
* resource_set: not repeatable
* addinfolink
* addinfotext

##### Field Definitions

* Nyucore vocabulary properties are defined in [../../lib/nyucore_metadata/vocabulary.rb](../../lib/nyucore_metadata/vocabulary.rb)
* Ichabod administrative vocabulary properties are in [../../lib/ichabod/vocabulary.rb](../../lib/ichabod/vocabulary.rb)
* Repeatability of properties is defined in [nyucore.rb](nyucore.rb)
* Facetability is defined in [../../lib/ichabod/nyucore_datastream.rb](../../lib/ichabod/nyucore_datastream.rb)

## Relationship to Data Model

The ichabod application somewhat conflates the data model with the Nyucore Metadata Application Profile. As we move towards having separate controllers and models for specific resource types, the current nycore.rb _model_ should be re-framed as a generic_item model, which uses a selection of Nyucore terms as appropriate. This will allow more complex models that draw on alternate Nyucore profiles.

There is an additional "collection_code" concept in Ichabod that is not defined as part of Nyucore. This code drives the "Collection" facet in Ichabod, and the collection field downstream of Ichabod, but is _not_ stored in Fedora at this time. Collection codes are defined in [model/nyucore/collections.rb](model/nyucore/collections.rb)

        TODO: Collection_code / Collection should likely be defined as part of Nyucore.