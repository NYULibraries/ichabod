module Ichabod
  module ResourceSet
    class Base

      extend Forwardable
      def_delegators :resources, :each

      class << self
        attr_reader :source_reader
        attr_accessor :prefix
      end

      attr_reader :options, :prefix, :editors, :before_creates

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

      def self.gather_superclass_attributes(attribute, klass=superclass)
        if klass.respond_to?(attribute)
          klass.send(attribute) + begin
            if klass.superclass.respond_to?(attribute)
              gather_superclass_attributes(attribute, klass.superclass)
            else
              []
            end
          end
        else
          []
        end
      end

      def self.editors
        @editors ||= gather_superclass_attributes(:editors)
      end

      def self.editor(*editors)
        self.editors.concat(editors.compact).uniq!
      end

      def self.before_creates
        @before_creates ||= gather_superclass_attributes(:before_creates)
      end

      def self.before_create(*before_creates)
        self.before_creates.concat(before_creates.compact).uniq!
      end

      # Default editor on all ResourceSets is the admin group
      editor :admin_group

      # Default to adding the edit groups on create
      before_create :add_edit_groups

      include Enumerable
      alias_method :size, :count

      def initialize(options = {})
        unless options.is_a?(Hash)
          options = OptionsInterpreter.new(options).interpret
        end
        @options = options
        @prefix = self.class.prefix
        @editors = self.class.editors.map(&:to_s)
        @before_creates = self.class.before_creates.map(&:to_sym)
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
          before_create_methods.each do |before_create_method|
            before_create_method.call(resource, nyucore)
          end
          nyucore if nyucore.save
        end.compact
      end

      def delete
        read_from_source if resources.empty?
        resources.collect do |resource|
          unless resource.is_a?(Resource)
            raise RuntimeError.new("Expecting #{resource} to be a Resource")
          end
          nyucore = Nyucore.find(resource.pid)
          # ActiveFedora::FixtureLoader.delete(resource.pid)
          nyucore.destroy
          nyucore
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
      def add_edit_groups(*args)
        nyucore = args.last
        nyucore.set_edit_groups(editors, []) unless editors.empty?
      end

      def before_create_methods
        @before_create_methods ||= begin
          before_creates.collect do |before_create|
            method(before_create)
          end
        end
      end

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
