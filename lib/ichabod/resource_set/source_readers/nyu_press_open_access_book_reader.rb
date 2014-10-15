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
            type: book['time'],
            language: book['language'],
            format: book['format']
          }
        end

        # Get the description from collection's JSON API for the given book
        # We need to grab the index for the particular book and use that
        # index to grab the relevant description
        def description_from_book(book)
          index = index_from_book(book)
          descriptions[index]['value'] unless index.blank?
        end

        # We get most of the data from the Solr document but some things aren't
        # stored (or are partially stored) in Solr. For that we need to use the
        # collection's JSON API. We can get specific fields for the whole
        # collection, as an Array with the indexes basically matching up.
        # In order to find the index for the book we want, we use the
        # playlist reference endpoint that matches the given book.
        def index_from_book(book)
          book_playlist_reference =
            book['im_field_playlist_ref'].first.to_s
          playlist_references.find_index do |playlist_reference|
            playlist_reference['raw_value'] == book_playlist_reference
          end
        end

        # The description field for all books as an Array
        def descriptions
          @descriptions ||= fields('field_description')
        end

        # The playlist reference field for all books as an Array
        def playlist_references
          @playlist_references ||= fields('field_playlist_ref')
        end

        # Get the field response as an Array
        def fields(field_name)
          MultiJson.load(field_endpoint(field_name).body)
        end

        # Call the "field" endpoint which returns JSON for the given field name
        def field_endpoint(field_name)
          endpoint_connection.get("/#{collection_code}/services/metadata/field/#{field_name}")
        end

        # Only grab the books from the returned Solr documents.
        # A collection level description is included so we want to exclude that.
        def books
          @books ||= solr_documents.find_all #do |solr_document|
            #solr_document[''] == 'rosie_book'
          #end
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

        # Solr params for grabbing 100 rows (more than we need) and
        # limiting to only the results for the Rosie collection
        def solr_params
          {
            #fq: "collection_code:#{collection_code}",
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
