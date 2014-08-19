module Ichabod
  module ResourceSet
    module SourceReaders
      class LibGuidesXmlFileReader < ResourceSet::SourceReader

        def read
          guides.collect do |guide|
            ResourceSet::Resource.new(resource_attributes_from_guide(guide))
          end
        end

        private
        extend Forwardable
        def_delegators :resource_set, :prefix, :filename

        def resource_attributes_from_guide(guide)
          {
            prefix: prefix,
            identifier: guide['identifier'],
            title: guide['title'],
            creator: guide['creator'],
            publisher: guide['publisher'],
            type: guide['type'],
            available: guide['accessURL'],
            description: guide['description'],
            edition: guide['edition'],
            series: guide['isPartOf'],
            version: guide['hasVersion'],
            date: guide['date'],
            format: guide['format'],
            language: guide['language'],
            relation: guide['relation'],
            rights: guide['rights'],
            subject: guide['subject']
          }
        end

        def guides
          @guides ||= xml['guides']
        end

        def xml
          @xml ||= MultiXml.parse(file)
        end

        def file
          @file ||= File.new(filename)
        end
      end
    end
  end
end
