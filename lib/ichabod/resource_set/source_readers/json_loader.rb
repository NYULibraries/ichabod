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
            #hsh[k] = v.is_a?(Array) ? entity[parse_data_map(v)] : v
            hsh[k] = v.is_a?(Array) ? parse_data_map(entity,v) : v
          }
          hsh
                    binding.pry
        end
        def parse_data_map(entity,map)
          # this works only if for json hashes that have a single value, not
          # for multi dimensional arrays, i.e. ['metadata']['field_name']['value']

            value = entity[map[0]]
            if map.size == 1
               #binding.pry
               value
            else
              map_arr = map.drop(1)
              index = 0
              recurse_through_hash(value,map_arr)
            end
        end

        def recurse_through_hash(rsp_hsh,map_arr)
          new_map_key = map_arr.first
          if rsp_hsh.is_a?(Hash) and rsp_hsh.has_key?(new_map_key)
            rsp_hsh = rsp_hsh[new_map_key]
            map_arr = map_arr.drop(1)
            recurse_through_hash(rsp_hsh,map_arr)
          else
            rsp_hsh.is_a?(Array) ? rsp_hsh[0] : rsp_hsh
          end


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
