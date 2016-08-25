module Ichabod
  module ResourceSet
    module SourceReaders
      require 'faraday'
      require 'multi_json'
      
      class TheLiberatorReader < ResourceSet::SourceReader
        FORMAT = "[TBD]"
        def read
          entities.collect do |entity|
            ResourceSet::Resource.new(resource_attributes_from_entities(entity))
          end
        end

        private
        extend Forwardable
        def_delegators :resource_set, :endpoint_url, :collection_code, :start, :rows

        def resource_attributes_from_entities(entity)
          # {
          #   prefix: resource_set.prefix,
          #   identifier: entity['id'],
          #   isbn: entity['id'],
          #   title: entity['title'],
          #   creator: entity['author'],
          #   available: entity['handle'],
          #   citation: entity['handle'],
          #   date: entity['date'],
          #   description: entity['description'],
          #   type: FORMAT,
          #   language: entity['language'],
          #   format: FORMAT
          # }
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
            rows: rows,
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
      end
    end
  end
end
