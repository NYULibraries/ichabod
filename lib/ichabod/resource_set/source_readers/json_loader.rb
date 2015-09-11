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
          # populating hash which will eventually become an nyucore object
          hsh = {}
          hsh[:prefix] = resource_set.prefix
          
          # set data map is the map of keys that
          # contain values relevant to the records
          # being ingested
          set_data_map.each_pair { |k,v|
            hsh[k] = v.is_a?(Array) ? parse_data_map(entity,v) : v
          }
          hsh
        end

        # parse response hash with keys specified in map array
        def parse_data_map(entity,map)
            # getting value of entity and the first element in the map array
            value = entity[map[0]]
            # if array that contains mapping value
            # only has one element
            if map.size == 1
               value
            else
              # otherwise recurse through nested hash
              # sometimes the json response is like this:
              # response_hash = {response: docs[ {metadata: {identifier: {label: "Identifier", value:"id1"}}}]}
              # and the value needed  from the response hash is response_hash['metadata']['identifier']['value']
              # The data map being sent(map is the argument name in the method)
              # is an array of fields listed in order to get the value, 
              # i.e. map = ['metadata','identifier','value']
              # so, this code is assigning the map array to the first level of the nested hash
              # response_hsh['metadata'] which gives us {identifier: {label: "Identifier", value:"id1"}}
              # The method recurse_through_hash processes the rest of the hash until it gets the value
              #
              # dropping the first element of map since 
              # it was already used to the var "value"
              #
              map_arr = map.drop(1)

              # sending the first level of nested hash to the method
              # to get the value
              recurse_through_hash(value,map_arr)
            end
        end

        def recurse_through_hash(rsp_hsh,map_arr)
          # grabbing key from the first element in array that 
          # contains mapping
          new_map_key = map_arr.first
          if rsp_hsh.is_a?(Hash) and rsp_hsh.has_key?(new_map_key)

            # re-assign response hash to required hash with the key
            # which is a nested hash
            rsp_hsh = rsp_hsh[new_map_key]

            # drop the now unnecessary key in the mapping array
            map_arr = map_arr.drop(1)

            # recurse with new arguments
            recurse_through_hash(rsp_hsh,map_arr)
          else

            # sometimes get a value as an array instead of just the value
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

        # hash of user and password to pass on to endpoint connection
        def auth
          { user: authentication[0], password: authentication[1]} unless authentication.blank?
        end

        # Use Faraday to connect to the collection's JSON API
        def endpoint_connection
          @endpoint_connection ||= Faraday.new(url: endpoint_url) do |faraday|
            faraday.request :basic_auth, auth[:user], auth[:password] unless authentication.blank?
            faraday.params = datasource_params unless datasource_params.blank?
            faraday.adapter :net_http
          end
        end
      end
    end
  end
end
