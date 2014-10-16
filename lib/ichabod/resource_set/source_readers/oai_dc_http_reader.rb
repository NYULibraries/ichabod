module Ichabod
  module ResourceSet
    module SourceReaders
      class OaiDcHttpReader < ResourceSet::SourceReader
      require 'oai'
 
        def read
            records.collect do | record|
             ResourceSet::Resource.new(resource_attributes_from_record(record))
            end
        end

        private
        extend Forwardable
        def_delegators :resource_set, :endpoint_url, :set_handle, :load_number_of_records

        def resource_attributes_from_record(record)
          {
            prefix: resource_set.prefix,
            identifier: dc_attribute_from_record('identifier',record),
            title: dc_attribute_from_record('title',record),
            creator: dc_attribute_from_record('creator',record),
            publisher: dc_attribute_from_record('publisher', record),
            type: dc_attribute_from_record('type', record),
            description: dc_attribute_from_record('description', record),
            date: dc_attribute_from_record('date', record),
            format: dc_attribute_from_record('format', record),
            language: dc_attribute_from_record('language', record),
            relation: dc_attribute_from_record('relation', record),
            rights: dc_attribute_from_record('rights', record),
            subject: dc_attribute_from_record('subject', record)
          }
        end

        def dc_attribute_from_record(attribute,record)
          record.elements.each("*/dc:#{attribute}/text()").map(&:to_s)
        end

        def records
         @records=[]
         unless load_number_of_records.nil?
           response_oai.first(load_number_of_records).each { |oai_record| @records<<oai_record.metadata }
         else
           response_oai.each { |oai_record| @records<<oai_record.metadata }
         end
         @records            
        end

        def response_oai
          @response_oai ||= oai_client.list_records(set: set_handle)
        end

        def oai_client
          @oai_client ||= OAI::Client.new endpoint_url
        end
      end
    end
  end
end
