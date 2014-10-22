module Ichabod
  module ResourceSet
    module SourceReaders
      require 'faraday'
      require 'multi_json'
      # A reader for the Voices of the Food Revolution collection.
      # The collection is a Drupal website and its search is powered
      # by SOLR
      # Accessing the data through its SOLR index 
      #
      # The Solr index has most of what we need and quickly returns the set of
      # all documents for the collection. 
      #
      # The strategy we use is to query Solr for the collection and grab all the
      # "Interviews"
      # There is no format listed in the metadata, so creating a constant for the
      # collection

      class VoiceReader < ResourceSet::SourceReader
        Format = "Audio"
        def read
          interviews.collect do |interview|
            ResourceSet::Resource.new(resource_attributes_from_interview(interview))
          end
        end

        private
        extend Forwardable
        def_delegators :resource_set, :endpoint_url, :collection_code

        # This does not have handles in an easily parseable field
        # Therefore storing its actual url
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
            # it is beard_interview because this is how the collection is known
            # in the drupal site
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
        # limiting to only the results for the Voices(or Beard as it is known in the Drupal site) collection
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

        # Get Solr URL by removing the /select from the constant
        def solr_url
          @solr_url ||= endpoint_url.gsub(/\/select$/, '')
        end
      end
    end
  end
end
