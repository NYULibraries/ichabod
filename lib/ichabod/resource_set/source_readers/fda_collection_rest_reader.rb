module Ichabod
  module ResourceSet
    module SourceReaders
      class FdaCollectionRestReader < ResourceSet::SourceReader
        require 'rest-client'

        def read
          records.collect do |record|
            ResourceSet::Resource.new(resource_attributes_from_record(record))
          end
        end

        private
        extend Forwardable
        def_delegators :resource_set, :fda_collection_id

        def resource_attributes_from_record(record)
          {
              prefix: resource_set.prefix,
              available: available_link_from_record(record),
              identifier: dc_attribute_from_record('identifier', record),
              title: dc_attribute_from_record('title', record),
              creator: dc_attribute_from_record('creator', record),
              publisher: dc_attribute_from_record('publisher', record),
              type: dc_attribute_from_record('type', record),
              description: dc_attribute_from_record('description', record),
              date: dc_attribute_from_record('date.issued', record),
              format: dc_attribute_from_record('format', record),
              language: dc_attribute_from_record('language', record),
              relation: dc_attribute_from_record('relation', record),
              rights: dc_attribute_from_record('rights', record),
              subject: dc_attribute_from_record('subject', record)
          }
        end

        def dc_attribute_from_record(attribute, record)
          values = []
          record['metadata'].each do |element|
            if element['key'].include? "dc.#{attribute}"
              values << element['value']
            end
          end
          values
        end

        def available_link_from_record(record)
          values = []
          record['metadata'].each do |element|
            if element['key'].include? "dc.identifier"
              values << element['value'] if element['value'].include? "handle"
            end
          end
          values
        end

        def records
          @records=[]
          unless get_collection_items.nil?
            @records = get_collection_items
          end
          @records
        end

        def get_collection_items
          token = fda_authenticate
          parameters = {
              :url => ENV['FDA_REST_URL'] + '/collections/' + fda_collection_id + '/items',
              :method => :get,
              :verify_ssl => false,
              :headers => {
                  'Accept' => 'application/json',
                  :params => {
                      :expand => 'metadata',
                      :limit => 1000,
                      'rest-dspace-token' => token
                  }
              }
          }
          response = RestClient::Request.execute(parameters)
          fda_logout(token)
          JSON.parse(response)
        end

        def fda_authenticate
          parameters = {
              :url => ENV['FDA_REST_URL'] + '/login',
              :method => :post,
              :verify_ssl => false,
              :payload => {
                  :email => ENV['FDA_REST_USER'],
                  :password => ENV['FDA_REST_PASS']
              }.to_json,
              :headers => {
                  'Content-Type' => 'application/json'
              }
          }
          RestClient::Request.execute(parameters)
        end

        def fda_logout(token)
          parameters = {
              :url => ENV['FDA_REST_URL'] + '/logout',
              :method => :post,
              :verify_ssl => false,
              :headers => {
                  'Content-Type' => 'application/json',
                  'rest-dspace-token' => token
              }
          }
          RestClient::Request.execute(parameters)
        end

      end
    end
  end
end
