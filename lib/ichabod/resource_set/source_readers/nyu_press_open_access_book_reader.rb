module Ichabod
  module ResourceSet
    module SourceReaders
      require 'faraday'
      require 'multi_json'
      
      class NyuPressOpenAccessBookReader < ResourceSet::SourceReader

        def read
          books.collect do |book|
            ResourceSet::Resource.new(resource_attributes_from_book(book))
          end
        end

        private
        extend Forwardable
        def_delegators :resource_set, :endpoint_url, :collection_code

        def resource_attributes_from_book(book)
          {
            prefix: resource_set.prefix,
            identifier: book['id'],
            title: book['title'],
            available: book['handle'],
            citation: book['handle'],
            date: book['date'],
            description: book['description'],
            type: book['type'],
            language: book['language'],
            format: book['format']
          }
        end
        
        def books
          @books ||= solr_documents.find_all           
        end

        def solr_documents
          @solr_documents ||= solr_response['docs']
        end

        def solr_response
          @solr_response ||= solr_select['response']
        end

        # Select all the documents from Solr for the collection
        def solr_select
          @solr_select ||= solr.select(params: solr_params)
        end

        # Solr params for grabbing 100 rows (more than we need)
        def solr_params
          {
            rows: 100
          }
        end

        # Use RSolr to connect to Solr
        def solr
          @solr ||= RSolr.connect(url: solr_url)
        end

        # Get Solr URL by removing the /select from the end of the discovery
        # URL that we got from the collection's JSON API
        def solr_url
          @solr_url ||= discovery_url.gsub(/\/select$/, '')
        end

        # Get the URL of the discovery service from the collection's JSON API
        def discovery_url
          @discovery_url ||= discovery_json['url']
        end

        # Get the discovery response as a Hash
        def discovery_json
          @discovery_json ||= MultiJson.load(discovery_endpoint.body)
        end

        # Call the "discovery" endpoint which returns JSON for the discovery
        # service for the collection
        def discovery_endpoint
          @discovery_endpoint ||=
            endpoint_connection.get("/sources/discovery.json")
        end

        # Use Faraday to connect to the collection's JSON API
        def endpoint_connection
          @endpoint_connection ||= Faraday.new(url: endpoint_url) do |faraday|
            faraday.adapter :net_http
          end
        end
      end
    end
  end
end
