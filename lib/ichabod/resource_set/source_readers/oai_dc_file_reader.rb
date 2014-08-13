module Ichabod
  module ResourceSet
    module SourceReaders
      class OaiDcFileReader < ResourceSet::SourceReader
        OAI_DC_URI = 'http://www.openarchives.org/OAI/2.0/oai_dc/'
        DC_URI = 'http://purl.org/dc/elements/1.1/'
        NYU_URI = 'http://purl.org/nyu/digicat/'

        def read
          records.collect do |record|
            ResourceSet::Resource.new(resource_attributes_from_record(record))
          end
        end

        private
        def resource_attributes_from_record(record)
          {
            identifier: dc_attribute_from_record('identifier', record),
            title: dc_attribute_from_record('title', record),
            creator: dc_attribute_from_record('creator', record)
            publisher: dc_attribute_from_record('publisher', record),
            type: dc_attribute_from_record('type', record),
            available: nyu_attribute_from_record('accessURL', record),
            description: dc_attribute_from_record('description', record),
            edition: nyu_attribute_from_record('edition', record),
            series: dc_attribute_from_record('isPartOf', record),
            version: dc_attribute_from_record('hasVersion', record),
            date: dc_attribute_from_record('date', record),
            format: dc_attribute_from_record('format', record),
            language: dc_attribute_from_record('language', record),
            relation: dc_attribute_from_record('relation', record),
            rights: dc_attribute_from_record('rights', record),
            subject: dc_attribute_from_record('subject', record)
          }
        end

        def dc_attribute_from_record(attribute, record)
          content_from_nodes(record.xpath(".//dc:#{attribute}", dc: DC_URI))
        end

        def nyu_attribute_from_record(attribute, record)
          content_from_nodes(record.xpath(".//nyu:#{attribute}", nyu: NYU_URI))
        end

        def content_from_nodes(nodes)
          nodes.collect do |node|
            node.content.gsub('\\\'', '\'')
          end
        end

        def records
          @records ||= xml_document.xpath('//oai_dc:dc', 'oai_dc' => OAI_DC_URI)
        end

        def xml_document
          @xml_document ||= Nokogiri::XML(File.open(filename))
        end

        def prefix
          @prefix ||= resource_set.prefix
        end

        def filename
          @filename ||= resource_set.filename
        end
      end
    end
  end
end
