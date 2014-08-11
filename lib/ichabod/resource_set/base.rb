module Ichabod
  module ResourceSet
    class Base

      extend Forwardable
      def_delegators :resources, :each

      cattr_reader :source_reader_class
      cattr_accessor :prefix

      attr_reader :options, :prefix

      def self.source_reader_class=(source_reader_class)
        unless source_reader_class.is_a?(Class)
          raise ArgumentError.new("Expecting #{source_reader_class} to be a Class")
        end
        unless source_reader_class.ancestors.include?(Ichabod::ResourceSet::SourceReader)
          raise ArgumentError.new("Expecting #{source_reader_class} to be a descendant of Ichabod::ResourceSet::SourceReader")
        end
        @@source_reader_class = source_reader_class
      end

      include Enumerable
      alias_method :size, :count

      def initialize(options = {})
        @options = options
        @prefix = self.class.prefix
      end

      def read_from_source
        @resources = source_reader.read
      end

      def method_missing(method_name, *args)
        if respond_to_missing?(method_name)
          options[method_name]
        else
          super
        end
      end

      def respond_to_missing?(method_name, include_private = false)
        options.has_key?(method_name) || super
      end

      private
      def resources
        (@resources || [])
      end

      def source_reader
        @source_reader ||= self.class.source_reader_class.new(self)
      end
    end
  end
end
