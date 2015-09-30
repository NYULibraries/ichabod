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
          entities.collect do |entity|
            ResourceSet::Resource.new(resource_attributes_from_entity(entity))
          end
        end

        private
        extend Forwardable
        def_delegators :resource_set, :endpoint_url, :collection_code, :start,
          :rows 

        def resource_attributes_from_entity(entity)
          {
            prefix: resource_set.prefix,
            identifier: entity['identifier'],
            title: entity['entity_title'],
            date: entity['created'],
            description: entity_description(entity),
            thumbnail: entity_representative_image(entity['representative_image']),
            available: entity_metadata_field_value('handle', entity),
            citation: entity_metadata_field_value('handle', entity),
            subject: entity_metadata_field_value('subject', entity),
            creator: entity_metadata_field_value('editor', entity),
            language: entity['language'],
            type: entity['type'].capitalize,
            format: FORMAT
          }
          
        end
        
        def entity_description(entity)
          value = entity_metadata_field_value('description', entity)
          value['safe_value']
        end

        def entity_representative_image(representative_image)
          representative_image['video_lg_thumbnails']
        end        
        
        def entity_metadata_field_value(entity_field_name, entity)
          if (entity['metadata'][entity_field_name])
            entity['metadata'][entity_field_name]['value']
          end
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
            start: start,
            rows: rows
          }
        end
        
        # Connect to collection JSON API
        def datasource
          @datasource ||= endpoint_connection.get(endpoint_url)
        end

        # Use Faraday to connect to the collection's JSON API
        def endpoint_connection
          @endpoint_connection ||= Faraday.new(url: endpoint_url) do |faraday|
            faraday.response :logger
            faraday.params = datasource_params
            faraday.adapter :net_http
          end
        end
        
      end

    end
  end
end
