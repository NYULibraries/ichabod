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
        raise Ichabod::MethodNotImplementedError.new('Subclasses should implement')
      end
    end
  end
end
