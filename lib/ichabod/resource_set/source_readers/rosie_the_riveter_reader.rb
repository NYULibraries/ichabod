module Ichabod
  module ResourceSet
    module SourceReaders
      require 'faraday'
      require 'multi_json'
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
            available: interview['url'],
            date: interview['ds_created'],
            description: description_from_interview(interview),
            type: interview['collection_type'],
            format: interview['bundle_name'],
            language: interview['ss_language']
          }
        end

        def description_from_interview(interview)
          index = index_from_interview(interview)
          descriptions[index]['value'] unless index.blank?
        end

        def index_from_interview(interview)
          interview_playlist_reference =
            interview['im_field_playlist_ref'].first.to_s
          playlist_references.find_index do |playlist_reference|
            playlist_reference['raw_value'] == interview_playlist_reference
          end
        end

        def descriptions
          @descriptions ||= fields('field_description')
        end

        def playlist_references
          @playlist_references ||= fields('field_playlist_ref')
        end

        def fields(field_name)
          MultiJson.load(field_endpoint(field_name).body)
        end

        def field_endpoint(field_name)
          endpoint_connection.get("/#{collection_code}/services/metadata/field/#{field_name}")
        end

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

        def solr_select
          @solr_select ||= solr.select(params: solr_params)
        end

        def solr_params
          {
            fq: "collection_code:#{collection_code}",
            rows: 100
          }
        end

        def solr
          @solr ||= RSolr.connect(url: solr_url)
        end

        def solr_url
          @solr_url ||= discovery_url.gsub(/\/select$/, '')
        end

        def discovery_url
          @discovery_url ||= discovery_json['url']
        end

        def discovery_json
          @discovery_json ||= MultiJson.load(discovery_endpoint.body)
        end

        def discovery_endpoint
          @discovery_endpoint ||=
            endpoint_connection.get("/#{collection_code}/sources/discovery")
        end

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
