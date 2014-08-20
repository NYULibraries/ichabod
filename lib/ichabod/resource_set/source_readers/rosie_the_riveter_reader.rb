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

        def read
          interviews.collect do |interview|
            ResourceSet::Resource.new(resource_attributes_from_interview(interview))
          end
        end

        private
        extend Forwardable
        def_delegators :resource_set, :endpoint_url, :collection_code, :user,
          :password

        def resource_attributes_from_interview(interview)
          {
            prefix: resource_set.prefix,
            identifier: interview['dc_identifier'],
            title: interview['label'],
            series: interview['collection_title'],
            available: interview['ss_handle'],
            date: interview['ds_created'],
            description: description_from_interview(interview),
            type: interview['collection_type'].capitalize,
            format: interview['bundle_name'],
            language: interview['ss_language']
          }
        end

        # Get the description from collection's JSON API for the given interview
        # We need to grab the index for the particular interview and use that
        # index to grab the relevant description
        def description_from_interview(interview)
          index = index_from_interview(interview)
          descriptions[index]['value'] unless index.blank?
        end

        # We get most of the data from the Solr document but some things aren't
        # stored (or are partially stored) in Solr. For that we need to use the
        # collection's JSON API. We can get specific fields for the whole
        # collection, as an Array with the indexes basically matching up.
        # In order to find the index for the interview we want, we use the
        # playlist reference endpoint that matches the given interview.
        def index_from_interview(interview)
          interview_playlist_reference =
            interview['im_field_playlist_ref'].first.to_s
          playlist_references.find_index do |playlist_reference|
            playlist_reference['raw_value'] == interview_playlist_reference
          end
        end

        # The description field for all interviews as an Array
        def descriptions
          @descriptions ||= fields('field_description')
        end

        # The playlist reference field for all interviews as an Array
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

        # Only grab the interviews from the returned Solr documents.
        # A collection level description is included so we want to exclude that.
        def interviews
          @interviews ||= solr_documents.find_all do |solr_document|
            solr_document['bundle'] == 'rosie_interview'
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
            fq: "collection_code:#{collection_code}",
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

        # Use Faraday to connect to the collection's JSON API
        def endpoint_connection
          @endpoint_connection ||= Faraday.new(url: endpoint_url) do |faraday|
            faraday.request :basic_auth, user, password
            faraday.adapter :net_http
          end
        end
      end
    end
  end
end
