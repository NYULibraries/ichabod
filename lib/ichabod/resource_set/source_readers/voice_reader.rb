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
      class VoiceReader < ResourceSet::SourceReader
        Format = "Audio"
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
            available: interview['url'],
            citation: interview['url'],
            date: interview['ds_created'],
            description: interview["sm_field_beard_description"][0],
            type: interview['collection_type'].capitalize,
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
          @solr_url ||= endpoint_url.gsub(/\/select$/, '')
        end
      end
    end
  end
end
