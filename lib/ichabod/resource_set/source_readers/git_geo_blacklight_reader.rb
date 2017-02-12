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
        URL="https://geo.nyu.edu/catalog"
        def resource_attributes_from_geoblacklight(gb)
          {
            prefix: resource_set.prefix,
            identifier: gb['dc_identifier_s'],
            available: "#{URL}/#{gb['layer_slug_s']}",
            title: gb['dc_title_s'],
            description: gb['dc_description_s'],
            publisher: gb['dc_publisher_s'],
            type: FORMAT,
            language: gb['dc_language_s'],
            format: FORMAT,
            creator: gb['dc_creator_sm'],
            subject: gb['dc_subject_sm'],
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

          if not(Dir.exist?(File.dirname(repo_url)))
            raise ArgumentError.new("Error: #{repo_url} must exist")
          end
          json_file = []
          file_entries = Dir.glob(repo_url)
          raise ArgumentError.new("No files here: #{repo}") if file_entries.blank?
          file_entries.each { |f|
            contents = IO.read(f)
            json_file = read_json_file(contents,json_file)
          }
          json_file

        end

        def parse_download_files

          # create ruby hash
          # from json data
          # downloaded from github repository
          data = read_layer_paths
          size = data.size
          json_file = []
          data.each do |str|
            unless str.blank?
              contents = open(str) { |fi| fi.read }
              json_file = read_json_file(contents,json_file)
            end
          end
          json_file
        end

        def read_json_file(contents,array)
          array.push(MultiJson.load(contents))
        end

        def read_layer_paths
          repo_url = "https://raw.githubusercontent.com/OpenGeoMetadata/edu.nyu/master/handle"
          filename = "geoblacklight.json"
          # read through layers.json
          # and store results in an array
          url = get_layer_path
          path = open(url) { |fi| fi.read }
          file_paths = []
          file_paths = MultiJson.load(path)
          download_urls = []
          file_paths.each do |p|
            download_urls.push("#{repo_url}/#{p}/#{filename}")
          end
          download_urls
        end

        def get_layer_path
          # get first tree
          get_layer = first_tree
          layer_download_url = nil
          get_layer.each do |d|
            if d[:name] == "layers.json" and d[:size] != 0
              layer_download_url = d[:download_url]
            end
          end
          layer_download_url
        end


        # Use Octokit to connect to harvest metadata from Github
        def get_client
          @client ||= Octokit::Client.new(:access_token => access_token)
        end
        def first_tree
          @client ||= get_client
          @contents = @client.contents(repo_url, :path => "handle?ref=master")
        end
      end
    end
  end
end
