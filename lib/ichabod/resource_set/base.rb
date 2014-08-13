module Ichabod
  module ResourceSet
    class Base

      extend Forwardable
      def_delegators :resources, :each

      class << self
        attr_reader :source_reader
        attr_accessor :prefix
      end

      attr_reader :options, :prefix, :editors

      def self.source_reader=(source_reader)
        unless source_reader.is_a?(Class)
          module_name = "Ichabod::ResourceSet::SourceReaders"
          class_name = source_reader.to_s.classify
          source_reader = "#{module_name}::#{class_name}".safe_constantize
          if source_reader.nil?
            raise ArgumentError.new("Expecting #{class_name} to be in SourceReaders")
          end
        end
        unless source_reader.is_a?(Class)
          raise ArgumentError.new("Expecting #{source_reader} to be a Class")
        end
        unless source_reader.ancestors.include?(Ichabod::ResourceSet::SourceReader)
          raise ArgumentError.new("Expecting #{source_reader} to be a descendant of Ichabod::ResourceSet::SourceReader")
        end
        @source_reader = source_reader
      end

      def self.editors
        @editors ||= []
      end

      def self.editor(*editors)
        self.editors.concat(editors.compact).uniq!
      end

      include Enumerable
      alias_method :size, :count

      def initialize(options = {})
        @options = options
        @prefix = self.class.prefix
        @editors = self.class.editors.map(&:to_s)
      end

      def read_from_source
        raise_runtime_error_if_no_source_reader_configured
        @resources = source_reader.read
      end

      def create
        read_from_source if resources.empty?
        resources.collect do |resource|
          unless resource.is_a?(Resource)
            raise RuntimeError.new("Expecting #{resource} to be a Resource")
          end
          nyucore = resource.to_nyucore
          nyucore.set_edit_groups(editors, []) unless editors.empty?
          nyucore if nyucore.save
        end.compact
      end

      def delete
        read_from_source if resources.empty?
        resources.collect do |resource|
          unless resource.is_a?(Resource)
            raise RuntimeError.new("Expecting #{resource} to be a Resource")
          end
          pid = resource.pid
          Nyucore.find(pid).destroy
        end
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
      def raise_runtime_error_if_no_source_reader_configured
        if self.class.source_reader.blank?
          raise RuntimeError.new("No source reader has been configured for the class #{self.class.name}")
        end
      end

      def resources
        (@resources || [])
      end

      def source_reader
        @source_reader ||= self.class.source_reader.new(self)
      end
    end
  end
end
