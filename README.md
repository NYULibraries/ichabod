# Ichabod - Hydra at NYU

A prototyping effort to bring [Hydra](http://projecthydra.org/) to NYU as a metadata augmentation system.

## What is Hydra?

The Hydra group describes Hydra as a "repository solution." True to this description it does strive to solve some issues presented by repository management and discovery. The repository in discussion is [Fedora](http://www.fedora-commons.org/), which NYU doesn't use currently but can be brought up to function as a repository for augmented metadata (where the content itself is housed in R-star or the Institutional Repository) and the Hydra stack can provide a customizable interface for back and front end.

Hydra is really just a collection of interweaving (open-source) technologies that provide a simple way to manage a Fedora repository: the [hydra gem](https://github.com/projecthydra/hydra), Fedora, [Solr](http://lucene.apache.org/solr/), [Blacklight](http://projectblacklight.org/). These technologies all revolve around the Ruby on Rails framework so we can easily integrate [NYU SSO](https://github.com/NYULibraries/authpds-nyu) and [shared assets](https://github.com/NYULibraries/nyulibraries-assets).

### Moving parts
* **The hydra gem** offers a Rails interface for creating, editing and deleting objects in Fedora through [ActiveFedora](https://github.com/projecthydra/active_fedora), which creates Ruby models as proxies for the Fedora-based ones. It also provides a DSL for interacting with [access controls](https://github.com/projecthydra/hydra-head/tree/master/hydra-access-controls) in Fedora. This is just a Hydra implementation of the [cancan](https://github.com/ryanb/cancan) authorization gem.
* **Fedora** is the repository itself: where the metadata and even content can be stored (i.e. book cover image, pdf of actual book page).
* **Solr** is fast Lucene-based open-source software. I believe we are all familiar with Solr. ActiveFedora uses the solrizer gem to push Fedora objects into a solr index in real time.
* **Blacklight** is a Rails engine gem that acts as a front-end discovery interface for Solr indexes.

## Hydra models

In Fedora an object can have many 'datastreams' which are either content for the object or metadata about the object. We create these datastreams as OM ([Opinionated Metadata](https://github.com/projecthydra/om): describes format of an xml doc in Ruby) terminologies to convert our Ruby objects into XML that ActiveFedora can push to Solr. OM lets us describe what our Solr index will look like.

For example, a model aping a Fedora-based Book object with title and multiple authors attributes would look like:

    class Book < ActiveFedora::Base
      include Hydra::AccessControls::Permissions

      has_metadata 'descMetadata', type: BookMetadata

      has_many :pages, :property => :is_part_of

      has_attributes :title, datastream: 'descMetadata', multiple: false
      has_attributes :author, datastream: 'descMetadata', multiple: true

    end

With a matching OM description:

    class BookMetadata < ActiveFedora::OmDatastream

      set_terminology do |t|
        t.root(path: "fields")
        t.title index_as: :stored_searchable
        t.author index_as: :stored_searchable
      end

      def self.xml_template
        Nokogiri::XML.parse("<fields/>")
      end

    end

## Gated access

Hydra fully supports gated access. In fact it's an integral part of Hydra's architecture.

### Access privileges

* By default there are three levels of access that can be granted: Discover, Read, Edit
* Custom privileges can be created as well. With CanCan you can!
* Privileges can be defined at the user or group level, there is also the possibilty of having a configurable role mapper for mass assigning of assigning based on an external system (i.e. Aleph).

### Granting access with the Rails console

To grant access on an object to a user through the console:

    b = Book.all.last
    b.discover_users = ["user123"]
    b.save

Now user123 has discover access to this book and can search for it but will not be allowed to click through to details or edit the object unless I grant read and edit privileges.

To grant access for all registered (i.e. signed-in) users to all Book objects we can do something like:

    Book.all.each {|book| book.read_groups = ["registered"]; book.save }

Because these permissions just appear as relationships between objects, checkboxes can easily be integrated into views to allow admin users to grant their own levels of access to objects they manage.  Thanks Rails!

Oh and did I mention these permissions are indexed into Solr as well. They also can be pulled directly out of Fedora if they are already defined in there so no double work has to be done.

## Starting from scratch

    ActiveFedora::Base.reindex_everything

## Big wins that come with implementing Hydra out of the box

*	Defining additional metadata
*	Defining access controls per object or class of objects
*	Defining relationships between objects (the Fedora RDF is translated to active record like database relations)

## Sample Data Ingest

Rake tasks available to ingest data from "ingest" directory.

    rake ichabod:load["./ingest/sdr.xml","sdr"]
    rake ichabod:load["./ingest/stern.xml","fda"]

... and to purge data based on same data files.

    rake ichabod:delete["./ingest/sdr.xml","sdr"]
    rake ichabod:delete["./ingest/stern.xlm","fda"]

## Resources

* Homepage: [http://projecthydra.org/](http://projecthydra.org/)
* Dive Into Hydra Tutorial: [https://github.com/projecthydra/hydra/wiki/Dive-into-Hydra](https://github.com/projecthydra/hydra/wiki/Dive-into-Hydra)
* Access Controler with Hydra Tutorial: [https://github.com/projecthydra/hydra-head/wiki/Access-Controls-with-Hydra](https://github.com/projecthydra/hydra-head/wiki/Access-Controls-with-Hydra)
* Tame your XML with OM Turotial: [https://github.com/projecthydra/om/wiki/Tame-your-XML-with-OM](https://github.com/projecthydra/om/wiki/Tame-your-XML-with-OM)
* Project Hydra on GitHub: [https://github.com/projecthydra/hydra](https://github.com/projecthydra/hydra)
* GitHub Wiki: [https://github.com/projecthydra/hydra/wiki/](https://github.com/projecthydra/hydra/wiki/)
* Duraspace Wiki: [https://wiki.duraspace.org/display/hydra/The+Hydra+Project](https://wiki.duraspace.org/display/hydra/The+Hydra+Project)
* IRC Channel: \#projecthydra
