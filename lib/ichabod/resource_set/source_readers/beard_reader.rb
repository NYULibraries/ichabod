module Ichabod
  module ResourceSet
    module SourceReaders
      require 'multi_json'
      # A reader for the Beard collection.
      # There are one access point for the collection
      #   - a Solr index
      #  
      #
      # The Solr index has most of what we need and quickly returns the set of
      # all documents for the collection. 
      #
      # The strategy we use is to query Solr for the collection, grab all the
      # "Interviews"

      class BeardReader < ResourceSet::SourceReader
        Format = "video"
        def read
          interviews.collect do |interview|
            ResourceSet::Resource.new(resource_attributes_from_interview(interview))
          end
        end

        private
        extend Forwardable
        def_delegators :resource_set

        def resource_attributes_from_interview(interview)
          {
            prefix: resource_set.prefix,
            identifier: interview['dc_identifier'],
            title: interview['label'],
            available: interview['url'],
            citation: interview['url'],
            date: interview['ds_created'],
            description: interview['sm_field_beard_description'],
            type: interview['bundle_name'].capitalize,
            # language: interview['ss_language'],
            format: Format
          }
        end

       
        # Only grab the interviews from the returned Solr documents.
        # A collection level description is included so we want to exclude that.
        def interviews
          @interviews ||= solr_documents.find_all do |solr_document|
            solr_document['bundle'] == 'beard_interview'
          end
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
            fq: "collection_code:#{resource_set.prefix}",
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
            endpoint_connection.get("/#{collection_code}/sources/discovery")
        end
      end
    end
  end
end
