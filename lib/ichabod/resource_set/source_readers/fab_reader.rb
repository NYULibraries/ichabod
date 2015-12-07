module Ichabod
  module ResourceSet
    module SourceReaders
      require 'faraday'
      require 'multi_json'

      # Reader for: "Archive of Contemporary Composers' Websites Collection"
      # Available via: the ArchiveIt JSON API
      #
      # The ArchiveIt API is not officially supported by the Internet Archive
      # (who run ArchiveIt), and therefore we're reverse engineering the API
      # with the knowledge that the API may change, or may not be supported at
      # all in the future.
      #
      # The JSON data that we care about has the following structure:
      #       # {
      #           sortFields: [...],
      #           results: { entities: [
      #                                 {canonicalUrl: ... ,
      #                                  waybackCalendar: ...},
      #                                 {canonicalUrl: ... ,
      #                                  waybackCalendar: ...},
      #                                 {...
      #                                ]
      #                     }
      #         }
      #
      # The ArchiveIt endpoint currently only returns 100 entities per GET,
      # however (at the time of this writing) there are 144 results.  This
      # means that we need multiple GET operations in order to collect all of
      # the entities for a given collection. The JSON response contains
      # several name/value pairs that can be used to determine how many GET
      # operations to perform.  These names are:
      #
      #  totalResultCount:
      #  numPages:
      #  nextPageURL:
      #
      # The algorithm to collect all entities is:
      #   pull from collection URL
      #   while nextPageURL present in response body
      #     pull again from nextPageURL and add results to entities
      #
      # From a scalability perspective, it may be better in large collections
      # to pull the JSON data and store it as a file, then parse the file,
      # instead of keeping everything in memory. The file-based reader
      # implementation is deferred to a future iteration.
      #
      # The strategy we use is to query the collection JSON API and process
      # all of entities returned.
      #
      # NOTE: the waybackCalendar URL can get long, and therefore cannot be
      #       used as the identifier for the object, because the Fedora pid
      #       string-length limit is 64 characters [1]. Therefore, an MD5
      #       digest of the waybackURL is used to generate the identifier.
      #
      # [1] https://wiki.duraspace.org/display/FEDORA37/Fedora+Identifiers
      class FabReader < ResourceSet::SourceReader
        FINDING_AIDS_URL = "http://dlib.nyu.edu/findingaids/html/"
        ARCHIVES_FILE = "archives.yml"

        def read
          entities.collect do |entity|
            ResourceSet::Resource.new(resource_attributes_from_entity(entity))
          end
        end

        private
        extend Forwardable
        def_delegators :resource_set, :endpoint_url, :query, :path, :collection_code

        def resource_attributes_from_entity(entity)
          {
            prefix:     resource_set.prefix,
            identifier: entity['id'],
            date:       entity['unit_date_ssm'],
            available:  gen_url(entity['repository_ssi'],entity['ead_ssi'],entity['parent_ssi'],entity['ref_ssi']),
            title:      entity['unittitle_ssm'],
            type:       entity['format_ssm'],
            location:   entity['location_ssm'],
            data_provider: get_archive(entity['repository_ssi']),
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
          rsp = datasource
          rsp = MultiJson.load(rsp.body)
          results = rsp['response']['docs']
          next_page = get_next_page(rsp)
          while next_page do
            rsp = MultiJson.load(datasource(next_page).body)
            results += rsp['response']['docs']
            next_page = get_next_page(rsp) 
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
        def datasource(page = nil)
          page_req = query + "&page=#{page}"
          url = page.nil? ?  query : page_req
          url = endpoint_url + url
          endpoint_connection.get(url)
         
        end
  
        # Use Faraday to connect to the collection's JSON API
        def endpoint_connection
          @endpoint_connection ||= Faraday.new(url: endpoint_url) do |faraday|
            #faraday.params = datasource_params
            faraday.adapter :net_http
          end

        end
      end
    end
  end
end
