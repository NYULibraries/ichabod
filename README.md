# Ichabod - Hydra at NYU

[![Build Status](https://travis-ci.org/NYULibraries/ichabod.svg?branch=development)](https://travis-ci.org/NYULibraries/ichabod)
[![Dependency Status](https://gemnasium.com/NYULibraries/ichabod.svg)](https://gemnasium.com/NYULibraries/ichabod)
[![Code Climate](https://codeclimate.com/github/NYULibraries/ichabod.png)](https://codeclimate.com/github/NYULibraries/ichabod)
[![Coverage Status](https://coveralls.io/repos/NYULibraries/ichabod/badge.png?branch=development)](https://coveralls.io/r/NYULibraries/ichabod?branch=development)

A prototyping effort to bring [Hydra](http://projecthydra.org/) to NYU as a metadata augmentation system.

##Ichabod project purpose:

The number of digital collections currently managed by NYU Library is steadily growing.  Different collections use different discovery mechanisms and different metadata standards. Several library departments joined their efforts to create a centralized metadata repository with a convenient search interface. Ichabod collects metadata for various electronic resources, gives collection administrators an option to add metadata for existing resources and create new metadata records, and will support export to other systems.

##Ichabod project workflow:

We decided to adopt Agile methodology and use test driven development pattern. Project owners collect user stories and add them to the Pivotal Tracker software. User stories are discussed at bi-weekly developers meetings. Those meetings are called Sprint planning meetings. After discussion each developer gets a user story for implementation. Between planning meetings the developer group meets every other day to briefly discuss progress made by each developer and other project related matters. Ichabod developers have different backgrounds and different areas of expertise and everybody in the development group benefits from the collaboration.

##Ichabod potential users:

Students, faculty, researchers - can search through collection metadata and get access to the actual content. Additionally, the NYU Library portal may be able to ingest Ichabod data directly.

## Sample Data Ingest

Rake tasks available to ingest data from "ingest" directory.
```
    rake ichabod:load['nyu_press_open_access_book','http://discovery.dlib.nyu.edu:8080/solr3_discovery/nyupress/select']
    # Load first five records only (start = 0, rows = 5)
    rake ichabod:load['nyu_press_open_access_book','http://discovery.dlib.nyu.edu:8080/solr3_discovery/nyupress/select','0','5']
```
```
    rake ichabod:load['faculty_digital_archive_ngo','https://archive.nyu.edu/request','hdl_2451_33605']
    # Load five records only (rows = 5)
    rake ichabod:load['faculty_digital_archive_ngo','https://archive.nyu.edu/request','hdl_2451_33605','5']
```
```
    rake ichabod:load['spatial_data_repository','./ingest/sdr.xml']
```
... and to purge data based on same data files.

    rake ichabod:delete['nyu_press_open_access_book','http://discovery.dlib.nyu.edu:8080/solr3_discovery/nyupress/select']
    rake ichabod:delete['faculty_digital_archive_ngo','https://archive.nyu.edu/request','hdl_2451_33605']
    rake ichabod:delete['spatial_data_repository','./ingest/sdr.xml']

## Resources

* [Ichabod Contributers Guide] (https://github.com/NYULibraries/ichabod/blob/master/CONTRIBUTING.md)
* [Project Hydra Homepage](http://projecthydra.org/)
* [Project Hydra @ GitHub](https://github.com/projecthydra/hydra)
* [Dive Into Hydra](https://github.com/projecthydra/hydra/wiki/Dive-into-Hydra)
* [Access Controls with Hydra](https://github.com/projecthydra/hydra-head/wiki/Access-Controls-with-Hydra)
* [More Hydra Tutorials](https://github.com/projecthydra/hydra/wiki)
* [The Hydra Project @ Duraspace](https://wiki.duraspace.org/display/hydra/The+Hydra+Project)
* IRC Channel: \#projecthydra
