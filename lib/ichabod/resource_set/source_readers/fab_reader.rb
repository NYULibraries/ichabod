module Ichabod
  module ResourceSet
    module SourceReaders
      require 'faraday'
      require 'multi_json'

      # Treating the special collections portal as an API
      class FabReader < ResourceSet::SourceReader
        # keeping these as constants in the source reader
        # because they will apply to all finding aids objects
        # being imported
        FINDING_AIDS_URL = "http://dlib.nyu.edu/findingaids/html/"
        ARCHIVES_FILE = "archives.yml"
        ENDPOINT_URL = "https://specialcollections.library.nyu.edu/search/catalog.json"

        def read
          entities.collect do |entity|
            ResourceSet::Resource.new(resource_attributes_from_entity(entity))
          end
        end

        private
        extend Forwardable
        def_delegators :resource_set, :query, :path, :collection_code, :page

        def resource_attributes_from_entity(entity)
          {
            prefix:     resource_set.prefix,
            identifier: entity['id'],
            date:       entity['unit_date_ssm'],
            available:  gen_url(entity['repository_ssi'],entity['ead_ssi'],entity['parent_ssi'],entity['ref_ssi']),
            title:      entity['unittitle_ssm'],
            type:       entity['format_ssm'],
            location:   entity['location_ssm'],
            repo:       get_archive(entity['repository_ssi']),
            data_provider: 'NYU',
            relation: [entity['collection_ssm'],entity['parent_unittitles_ssm']].join(': ')
          }

        end


        def gen_url(repo,ead,parent_ref,item_ref)
          FINDING_AIDS_URL + "#{repo}/#{ead}/dsc#{parent_ref}.html##{item_ref}"
        end

        # mapping value from FAB to the full form listed in the yml file
        def get_archive(repo)
          @repository ||= YAML.load_file(File.join(Rails.root, "config", ARCHIVES_FILE))['type']
          @repository[repo]
        end

        def entities
          results = []

          # if page is defined
          # get results for that one page
          # this is usually either for testing purposes
          # or if people want a specific page for some reason
          rsp = datasource(page)
          rsp = MultiJson.load(rsp.body)
          results = rsp['response']['docs']
          # if page is not defined
          # continue getting all the results
          if page.nil?
            next_page = get_next_page(rsp)
            while next_page do
              rsp = MultiJson.load(datasource(next_page).body)
              results += rsp['response']['docs']
              next_page = get_next_page(rsp) 
            end 
          end
          results
        end

        def get_next_page(rsp)
          rsp['response']['pages']['next_page']
        end

        # Connect to collection JSON API
        # ugly hack
        # I'd like to specify this in params but it's not being formatted in the form
        # that the FAB recognizes
        def datasource(pg = nil)
          page_req = query + "&page=#{pg}"
          url = pg.nil? ?  query : page_req
          url = ENDPOINT_URL + url
          endpoint_connection.get(url)
        end
  
        # Use Faraday to connect to the collection's JSON API
        def endpoint_connection
          @endpoint_connection ||= Faraday.new(url: ENDPOINT_URL) do |faraday|
            faraday.adapter :net_http
          end

        end
      end
    end
  end
end
