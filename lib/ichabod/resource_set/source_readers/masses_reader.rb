module Ichabod
  module ResourceSet
    module SourceReaders
      require 'faraday'
      require 'multi_json'
      # A reader for the The Masses collection.
      # The collection have a JSON API 
      #  - Get metadata for all books
      #  - Get metadata for a book by its identifier
      #
      # The strategy we use is to query the collection JSON API,
      # grab the requested amount of "Books".
      class MassesReader < ResourceSet::SourceReader

        def read
          entities.collect do |entity|
            ResourceSet::Resource.new(resource_attributes_from_entity(entity))
          end
        end

        private
        extend Forwardable
        def_delegators :resource_set, :endpoint_url, :collection_code, :resource_format, :resource_type, :start, :rows 

        def resource_attributes_from_entity(entity)
          {
            prefix: resource_set.prefix,
            identifier: entity['identifier'],
            title: entity_title(entity),
            available: entity_metadata_field_value('handle', entity),
            citation: entity_metadata_field_value('handle', entity),
            date: entity_metadata_field_value('publication_date', entity),
            description: entity_metadata_field_value('description', entity),
            subject: entity_metadata_field_value('subject', entity),
            creator: entity_metadata_field_value('editor', entity),
            language: entity_metadata_field_value('language', entity),
            type: resource_type.capitalize,
            format: resource_format.capitalize
          }
        end

        def entity_title(entity)
          entity['entity_title'] + ' ' + entity_metadata_field_value('description', entity).join(', ')
        end        

        def entity_metadata_field_value(entity_field_name, entity)
          entity['metadata'][entity_field_name]['value']
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
            # faraday.response :logger
            faraday.params = datasource_params
            faraday.adapter :net_http
          end
        end
        
      end

    end
  end
end
