module Ichabod
  module ResourceSet
    module SourceReaders
      require 'faraday'
      require 'multi_json'
      require 'digest'

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
      class ArchiveItAccwReader < ResourceSet::SourceReader

        ARCHIVE_IT_COLLECTION_CODE = '4049'

        def read
          entities.collect do |entity|
            ResourceSet::Resource.new(resource_attributes_from_entity(entity))
          end
        end

        private
        extend Forwardable
        def_delegators :resource_set, :endpoint_url, :collection_code

        def resource_attributes_from_entity(entity)
          {
            prefix:     resource_set.prefix,
            identifier: Digest::MD5.hexdigest(entity['waybackCalendar']),
            available:  entity['waybackCalendar'],
            version:    entity['canonicalUrl'],
            title:      entity['canonicalUrl'].gsub(%r{http(s)?://},'').gsub(%r{/\z},'')
            #                                  ^ strip protocol and any trailing slash
          }
        end

        def entities
          @entities ||= begin
                          result = []
                          query  = nil
                          begin
                            json = MultiJson.load(entities_endpoint(query).body)
                            result += json['results']['entities']
                            query   = json['results']['nextPageURL']
                          end while query
                          result
                        end
        end

        def entities_endpoint(query = '')
          path = "/collections/#{ARCHIVE_IT_COLLECTION_CODE}.json#{query}"
          endpoint_connection.get(path)
        end

        #https://archive-it.org/collections/4049.json

        # Use Faraday to connect to the collection's JSON API
        def endpoint_connection
          @endpoint_connection ||= Faraday.new(url: endpoint_url) do |faraday|
            faraday.adapter :net_http
          end
        end
      end
    end
  end
end
