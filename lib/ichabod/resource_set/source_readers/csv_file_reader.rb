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
        def_delegators :resource_set, :file_path, :load_number_of_records

        def records
          @records=[]
          unless load_number_of_records.nil?
            SmarterCSV.process(file_path).each { |csv_record| @records<<csv_record }
          else
           SmarterCSV.process(file_path,{:chunk_size=> load_number_of_records}).first do |csv_record_chunk|
                    csv_record_chunk.each { |csv_record| @records<<csv_record }
           end
          end
          @records
        end

        def resource_attributes_from_record(record)
          {
            prefix: resource_set.prefix,
            identifier: record[:"dc.identifier.uri"],
            title: record[:"dc.title" ],
            creator: record[:"dc.contributor.author" ],
            publisher: record[:"dc.contributor.publisher" ],
            type: record[:"dc.type.resource" ],
            type: record[:"dc.type[en_US]" ],
            description: record[:"dc.description.abstract" ],
            description: record[:"dc.description" ],
            date: record[:"dc.date.issued" ],
            format: record[:"dc.format" ],
            language: record[:"dc.language" ],
            rights: record[:"dc.rights" ],
            subject: record[:"dc.subject" ],
            subject: record[:"dc.coverage[en_US]" ],
            subject: record[:"dc.coverage.temporal" ]
          }
        end
      end
    end
  end
end
