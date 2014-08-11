module Ichabod
  module ResourceSet
    class SourceReader
      attr_reader :resource_set

      def initialize(resource_set)
        unless resource_set.is_a?(ResourceSet::Base)
          raise ArgumentError.new("Expecting #{resource_set} to be a Ichabod::ResourceSet::Base")
        end
        @resource_set = resource_set
      end

      # Public: Read from the ResourceSet's source
      # Returns an Array of Ichabod::ResourceSet::Resources
      def read
        raise RuntimeError.new("This is really just an interface that should be implemented by subclasses")
      end
    end
  end
end
