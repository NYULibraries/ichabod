module Ichabod
  module ResourceSet
    module SourceReaders
      class JsonLoader < ResourceSet::SourceReader
      require 'faraday'
      require 'multi_json'    
     
        def read
          endpoint_connection
        end

        private
        extend Forwardable
        def_delegators :resource_set, :endpoint_url, :collection_code, :datasource_params, :authentication

        def auth
          { user: authentication[0], password: authentication[1]} if authentication
        end

        # Use Faraday to connect to the collection's JSON API
        def endpoint_connection
          @endpoint_connection ||= Faraday.new(url: endpoint_url) do |faraday|
            faraday.request :basic_auth, auth[:user], auth[:password] if authentication
            faraday.params = datasource_params if datasource_params
            faraday.adapter :net_http
          end
        end
      end
    end
  end
end
