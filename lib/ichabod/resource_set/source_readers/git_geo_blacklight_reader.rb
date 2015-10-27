module Ichabod
  module ResourceSet
    module SourceReaders
      require 'octokit'
      require 'open-uri'
      require 'multi_json'
      
      class GitGeoBlacklightReader < ResourceSet::SourceReader

        def read
          if repo_url
            map.collect do |gb| 
             ResourceSet::Resource.new(resource_attributes_from_geoblacklight(gb))
            end
          end
        end

        private
        extend Forwardable
        def_delegators :resource_set, :collection_code, :repo_url, :access_token
        FORMAT = "Geospatial Data"
        def resource_attributes_from_geoblacklight(gb)
          {
            prefix: resource_set.prefix,
            identifier: gb['uuid'],
            available: gb['dc_identifier_s'],
            title: gb['dc_title_s'],
            description: gb['dc_description_s'],
            publisher: gb['dc_publisher_s'],
            type: FORMAT,
            language: gb['dc_language_s'], # there are multiple languages, need to handle that
            format: FORMAT,
            creator: gb['dc_creator_sm'],
            subject: gb['dc_subject_sm'], # need to handle multiple subjects
            date: gb['dct_issued_s'],
            rights:gb['dc_rights_s'],
            data_provider: gb['dct_provenance_s'],
            geometry: gb['layer_geom_type_s'],
            subject_spatial: gb['dct_spatial_sm'],
            subject_temporal: gb['dct_temporal_sm']
          }

        end

        def map
          # for testing purposes, we want to use static files
          # if there is no access token specified,
          # use the static files, else use the files listed
          # in the github repository

          json_file = access_token ? parse_download_files : read_static_files

        end

        def read_static_files

          # read the static files
          # create ruby hash from that
          # for testing purposes 

          if not(Dir.exists?(File.dirname(repo_url)))
            raise ArgumentError.new("Error: #{repo_url} must exist")
          end
          json_file = []
          file_entries = Dir.glob(repo_url)
          raise ArgumentError.new("No files here: #{repo}") if file_entries.blank?
          file_entries.each { |f|
            json_file.push(MultiJson.load(IO.read("#{f}")))
          }
          json_file
        
        end

        def parse_download_files

          # create ruby hash
          # from json data
          # downloaded from github repository
          
          data = read_download_files
          json_file = []
          
          data.each do |str|
            unless str.blank?
              json = MultiJson.load(str)
              json_file.push(json)
            end
          end
          json_file
        end

        def read_download_files
          # read through the download urls
          # and store results in an array

          urls = get_download_urls
          files = []
          dir = "/Users/Esha/dev/ichabod/ingest/sdr"
          count = 0
          urls.each do |url|
            geo_blacklight  = open(url) {|fi| fi.read }
            files.push(geo_blacklight)
          end
          files
        end

        def get_download_urls
          # get first tree
          get_dirs = first_tree

          json_file_paths = []
          # get json download urls 
          # by doing a recursive call to 
          # navigate the directories
          # and get the json file
          get_dirs.each do |d|
            next if d['size'] != 0
            path = d['path']
            sub_tree = @client.tree(repo_url,d['sha'], :recursive => true) 

            sub_tree[:tree].each do |t|
              if t['type'] == 'blob'
                full_path = "#{path}/#{t['path']}"
                download_url = @client.contents(repo_url, :path => full_path)['download_url'] 
                json_file_paths.push(download_url) 
              end
            end
          end
          json_file_paths
        end
      

        # Use Octokit to connect to harvest metadata from Github
        def get_client
          @client ||= Octokit::Client.new(:access_token => access_token) 
        end
        def first_tree
          @client ||= get_client
          @contents = @client.contents(repo_url)
        end
      end
    end
  end
end
