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
        def_delegators :resource_set, :file_path, :header_map, :csv_reader_options

        def records
          @records=[]
          SmarterCSV.process(file_path, csv_reader_options).each  do |csv_record|
            @records<<csv_record
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
            subject_spatial: dc_attribute_from_record("subject_spatial",record),
            language: dc_attribute_from_record("language",record),
            genre: dc_attribute_from_record("genre",record),
          }
        end

        #there are 2 ways to map columns in the csv file to nyucore fields
        #we either collect values from one or more columns separatelly and then map_header entry looks like this subject: ["subject", "subject_spatial" ]
        #or join several fields using different signs to join them and then map_header entry
        #looks like this publisher: [["publisher.place","publisher","date.issued"],[":",","]]
        #NOTE: we only can join columns that don't contain multiplr values, if maltiple value is present an error message will be thrown
        def dc_attribute_from_record(attribute,record)
          record_values=[]
          unless  header_map[:"#{attribute}"].nil?
              if header_map[:"#{attribute}"][0].kind_of?(Array)
                record_value=process_joined_columns(header_map[:"#{attribute}"],record)
                record_values<<record_value unless record_value.blank?
              else
                header_map[:"#{attribute}"].each do |map_header|
                unless  record[:"#{map_header}"].nil?
                  record[:"#{map_header}"].to_s.split("||").each { |record_value| record_values<<record_value.to_s }
                end
              end
            end
          end
          record_values
        end

        def process_joined_columns(map_header,record)
          columns=map_header[0]
          join_signs=map_header[1]
          values_to_merge=[]
          record_value=''
          #check that we have a correct number of join signs, if not - throw an error and quite
          if join_signs.size!=columns.size-1
            raise ArgumentError.new("number of join signs and columns to be joined do not match. Please correct your headers map")
          end
          map_header[0].each do |column|
            value=record[:"#{column}"].to_s||''
            #check that we are not trying to merge multivalued columns, if we do -throw an error and quite
            if value.include?("||")
              raise ArgumentError.new("You have muliple values in the column #{column}. That columns can't be joined")
            end
            values_to_merge<<value.to_s
          end
          map_header[1].each_with_index do |sign, index|
            if index==0
              if !values_to_merge[index].blank?
                record_value=[values_to_merge[index],values_to_merge[index+1]].join(sign)
              else
                record_value=values_to_merge[index+1] unless values_to_merge[index+1].blank?
              end
            else
              if !record_value.blank?
               record_value=[record_value,values_to_merge[index+1]].join(sign) unless values_to_merge[index+1].blank?
              else
                record_value=values_to_merge[index+1] unless values_to_merge[index+1].blank?
              end
            end
          end
          return record_value
        end
      end
    end
  end
 end