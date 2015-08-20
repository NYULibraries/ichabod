module Ichabod
  module ResourceSet
    module SourceReaders
      class JsonLoader < ResourceSet::SourceReader
      require 'faraday'
      require 'multi_json'    
     
        def read
          entities.collect do |entity|
            ResourceSet::Resource.new(resource_attributes_from_entities(entity))
          end
        end

        private
        extend Forwardable
        def_delegators :resource_set, :endpoint_url, :rsp_field, :each_rec_field, :datasource_params, :authentication, :set_data_map

        def resource_attributes_from_entities(entity)
          hsh = {}
          hsh[:prefix] = resource_set.prefix
          set_data_map.each_pair { |k,v|
            hsh[k] = entity[parse_data_map(v)] 
                binding.pry if k =~ /type/
          }
          hsh
           binding.pry
        end
        def parse_data_map(map)
          map.is_a?(Array) ? map[0] : map 
        end
        def entities
          @entities ||= datasource_response[each_rec_field]
        end  

        def datasource_response
          @datasource_response ||= datasource_json[rsp_field]
        end

        def datasource_json
          @datasource_json ||= MultiJson.load(datasource.body)
        end

        def datasource
          @datasource ||= endpoint_connection.get(endpoint_url)
        end

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
