module Ichabod
  module ResourceSet
    module SourceReaders
      require 'faraday'
      require 'multi_json'
      # A reader for the Real Rosie the Riveter collection.
      # There are two access points for the collection
      #   - a Solr index
      #   - a JSON API
      #
      # The Solr index has most of what we need and quickly returns the set of
      # all documents for the collection. The JSON API return field level
      # metadata for the collection items as an Array for a given metadata
      # field. For example a call to services/metadata/field/field_description
      # returns an Array of the "descriptions" of all the interviews in order,
      # e.g.
      #   [ {"value":"Interview 1 description"},
      #     {"value":"Interview 2 description"},
      #     ... ]
      #
      # The strategy we use is to query Solr for the collection, grab all the
      # "Interviews", use the Solr data and only go to the JSON API if we need
      # it.
      #
      # When we do need the JSON API, we first match the interview from Solr to
      # its index in the JSON API and then grab the relevant field for that
      # index from the JSON API.
      class RosieTheRiveterReader < ResourceSet::SourceReader
        FORMAT = "Video"
        def read
          response.collect do |interview|
            ResourceSet::Resource.new(resource_attributes_from_interview(interview))
          end
        end

        private
        extend Forwardable
        def_delegators :resource_set, :endpoint_url, :collection_code, :user,
          :password, :dataset_size

        def resource_attributes_from_interview(interview)
          {
            prefix: resource_set.prefix,
            identifier: interview['identifier'],
            title: interview['entity_title'],
            available: interview_metadata_field_value('handle',interview),
            citation: interview_metadata_field_value('handle',interview),
            description: interview_description(interview),
            type: FORMAT,
            format: FORMAT
          }
        end
        def interview_metadata_field_value(metadata_field_name, response)
          response['metadata'][metadata_field_name]['value']
        end     

        def interview_description(response)
          response['metadata']['description']['value']['value']
        end     

        # Only grab the interviews from the returned Solr documents.
        # A collection level description is included so we want to exclude that.
        def response
          @response ||= datasource_response['docs']
        end
        # Params to send with the request to the JSON API
        def datasource_params
          {
            rows: dataset_size
          }
        end
        def datasource_response
          @datasource_response ||= datasource_json['response']
        end

        def datasource_json
          @datasource_json ||= MultiJson.load(datasource.body)
        end

         # Connect to collection JSON API
        def datasource
          @datasource ||= endpoint_connection.get(endpoint_url)
        end

        # Use Faraday to connect to the collection's JSON API
        def endpoint_connection
          @endpoint_connection ||= Faraday.new(url: endpoint_url) do |faraday|
            faraday.request :basic_auth, user, password
            faraday.params = datasource_params
            faraday.adapter :net_http
          end
        end
      end
    end
  end
end
