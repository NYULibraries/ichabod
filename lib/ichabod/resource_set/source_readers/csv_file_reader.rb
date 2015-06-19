module Ichabod
  module ResourceSet
    module SourceReaders
      class CsvFileReader < ResourceSet::SourceReader
      require 'smarter_csv'


        def read
          records.collect do | record|
             ResourceSet::Resource.new(resource_attributes_from_record(record))
          end
        end

        private
        extend Forwardable
        def_delegators :resource_set, :file_path, :load_number_of_records, :header_map

        def records
          @records=[]
          unless load_number_of_records.nil?
           SmarterCSV.process(file_path,{:chunk_size=> load_number_of_records}).first do |csv_record_chunk|
                    csv_record_chunk.each { |csv_record| @records<<csv_record }
           end
          else
           SmarterCSV.process(file_path).each { |csv_record| @records<<csv_record }
          end
          @records
        end

        def resource_attributes_from_record(record)
          {
            prefix: resource_set.prefix,
            identifier: dc_attribute_from_record("identifier",record),
            title: dc_attribute_from_record("title",record),
            creator: dc_attribute_from_record("creator",record),
            publisher: dc_attribute_from_record("publisher",record),
            type: dc_attribute_from_record("type",record),
            description: dc_attribute_from_record("description",record),
            date: dc_attribute_from_record("date",record),
            format: dc_attribute_from_record("format",record),
            rights: dc_attribute_from_record("rights",record),
            subject: dc_attribute_from_record("subject",record),
          }
        end

        def dc_attribute_from_record(attribute,record)
          record_values=[]
          unless  header_map[:"#{attribute}"].nil?
            header_map[:"#{attribute}"].each do |map_header|
              unless  record[:"#{map_header}"].nil?
                record[:"#{map_header}"].to_s.split("||").each { |record_value| record_values<<record_value.to_s }
              end
            end
          end
          record_values
        end
      end
    end
  end
end
