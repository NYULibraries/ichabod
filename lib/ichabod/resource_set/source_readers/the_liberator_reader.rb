module Ichabod
  module ResourceSet
    module SourceReaders
      require 'faraday'
      require 'multi_json'
      
      class TheLiberatorReader < ResourceSet::SourceReader
        DATA_PROVIDER = "NYU"
        FORMAT = "Journal"

        def read
          entities.collect do |entity|
            ResourceSet::Resource.new(resource_attributes_from_entities(entity))
          end
        end

        private
        extend Forwardable
        def_delegators :resource_set, :endpoint_url, :collection_code, :start, :rows

        def resource_attributes_from_entities(entity)
          {
              available: entity['ss_handle'],
              creator: entity['sm_author'],
              data_provider: DATA_PROVIDER,
              date: parse_solr_date( entity['ss_publication_date_text'] ),

              description: parse_description_from_entity( entity ),

              identifier: entity['ss_handle'],
              language: entity['sm_language_code'],
              prefix: resource_set.prefix,
              publisher: entity['sm_publisher'],
              series: entity['sm_field_volume'],
              subject: entity['sm_subject_label'],
              title: entity['ss_title'],
              type: FORMAT
          }
        end
        
        def entities
          @entities ||= datasource_response['docs']
        end

        def datasource_response
          @datasource_response ||= datasource_json['response']
        end

        def datasource_json
          @datasource_json ||= MultiJson.load(datasource.body)
        end

        # Params to send with the request to the JSON API
        def datasource_params
          {
            # We want to make sure we don't load the collection record, but only
            # records that belong to that collection record.
            fq: 'sm_collection_code:theliberator',

            rows: rows,
            sort: 'id asc',
            start: start,
            wt: 'json'
          }
        end

        # Connect to collection JSON API
        def datasource
          @datasource ||= endpoint_connection.get(endpoint_url)
        end

        # Use Faraday to connect to the collection's JSON API
        def endpoint_connection
          @endpoint_connection ||= Faraday.new(url: endpoint_url) do |faraday|
            faraday.params = datasource_params
            faraday.adapter :net_http
          end
        end

        def parse_solr_date(date_string)
          # We are expecting a publication date with no time, so we provide our
          # own.
          time_part = "T00:00:00Z"
          # Date.parse("January 1909").iso8601 returns "1909-01-01" -- note the
          # addition of the day.
          "#{Date.parse(date_string).iso8601}#{time_part}"
        end

        def parse_description_from_entity(entity)
          # Using the style described in http://www.chicagomanualofstyle.org/16/ch14/ch14_sec180.html:
          #     "[journal] [volume - in Arabic numerals], [issue, optional] ([date])".
          # In our record, that would be:
          #     * Journal: hardcoded "The Liberator", because the `ss_title` field includes the date
          #     * Volume: `sm_field_volume`
          #     * Issue: omitted, because date includes month
          #     * Date: In parentheses, `ss_publication_date_text`

          journal = "The Liberator"

          volume = entity['sm_field_volume']               ?
                      " #{entity['sm_field_volume'][ 0 ]}" :
                      ''
          publication_date = entity['ss_publication_date_text']

          "#{journal}#{volume}, (#{publication_date})"
        end
      end
    end
  end
end
