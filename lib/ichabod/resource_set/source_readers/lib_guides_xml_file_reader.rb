module Ichabod
  module ResourceSet
    module SourceReaders
      class LibGuidesXmlFileReader < ResourceSet::SourceReader

        def read
          published_guides.collect do |guide|
            ResourceSet::Resource.new(resource_attributes_from_guide(guide))
          end
        end

        private
        extend Forwardable
        def_delegators :resource_set, :prefix, :filename, :collection_code

        def resource_attributes_from_guide(guide)
          {
            prefix: prefix,
            identifier: guide['URL'],
            title: guide['NAME'],
            creator: guide['OWNER']['NAME'],
            type: 'Research Guide',
            available: (guide['FRIENDLY_URL'] || guide['URL']),
            description: guide['DESCRIPTION'],
            date: guide['LAST_UPDATE'],
            subject: subjects_from_guide(guide)
          }
        end

        def subjects_from_guide(guide)
          categories = guide['CATEGORIES']
          unless categories.nil?
            categories = categories['CATEGORY']
            if categories.is_a? Array
              categories.collect do |category|
                category['CATEGORY_NAME']
              end
            elsif categories.is_a? Hash
              categories['CATEGORY_NAME']
            end
          end
        end

        def published_guides
          @published_guides ||= guides.find_all do |guide|
            guide['STATUS'] == 'Published'
          end
        end

        def guides
          @guides ||= xml['LIBGUIDES']['GUIDES']['GUIDE']
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
