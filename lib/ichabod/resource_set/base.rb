module Ichabod
  module ResourceSet
    class Base

      # Filename and location for yml file that contains id and value
      RESTRICT_FILENAME = "config/access_rights.yml"
      extend Forwardable
      def_delegators :resources, :each

      class << self
        attr_reader :source_reader
        attr_accessor :prefix
      end

      attr_reader :prefix, :editors, :before_loads, :set_restrictions

      def self.source_reader=(source_reader)
        unless source_reader.is_a?(Class)
          module_name = "Ichabod::ResourceSet::SourceReaders"
          # Use :camelize to get the CamelCase version of the string
          #   "lib_guides".camelize
          #   # => "LibGuides"
          # We don't use :classify since it makes the class name singular
          #   "lib_guides".classify
          #   # => "LibGuide"
          class_name = source_reader.to_s.camelize
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

      # Since the class attributes are defined as instance variables on a Class
      # we need to make sure we force inheritance by grabbing the superclass(es)
      # instance variables as well. We do this through recursion so that all
      # super classes that have the attributes are gathered.
      #
      # Example
      #   class SubClass < Base
      #     editor :admin_group
      #   end
      #
      #   class SubClass < Base
      #     editor :editor1
      #   end
      #
      #   class SubSubClass < SubClass
      #     editor :editor2
      #   end
      #
      # without forcing inheritance
      #   SubSubClass.editors
      #   # =>  :editor2
      #
      # with forcing inheritance through recursion
      #   SubSubClass.editors
      #   # =>  :admin_group, :editor1, :editor2
      #
      # We want inheritance, so that's what this method gives us
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

      def self.set_restrictions
        @set_restrictions ||= gather_superclass_attributes(:set_restrictions)
      end

      def self.set_restriction(*restrictions)
        self.set_restrictions.concat(restrictions.compact).uniq!
      end

      def self.before_loads
        @before_loads ||= gather_superclass_attributes(:before_loads)
      end

      def self.before_load(*before_loads)
        self.before_loads.concat(before_loads.compact).uniq!
      end

      # Default editor on all ResourceSets is the admin group
      editor :admin_group

      # Default to adding the edit groups on create
      before_load :add_edit_groups

      # Default to adding the ResourceSet on create
      before_load :add_resource_set

      include Enumerable
      alias_method :size, :count

      def initialize(*args)
        @prefix = self.class.prefix
        @editors = self.class.editors.map(&:to_s)
        @before_loads = self.class.before_loads.map(&:to_sym)
        @set_restrictions = self.class.set_restrictions.join("")
      end

      def read_from_source
        raise_runtime_error_if_no_source_reader_configured
        @resources = source_reader.read
      end

      def load
        read_from_source if resources.empty?
        resources.collect do |resource|
          unless resource.is_a?(Resource)
            raise RuntimeError.new("Expecting #{resource} to be a Resource")
          end
          nyucore = resource.to_nyucore
          before_load_methods.each do |before_load_method|
            before_load_method.call(resource, nyucore)
          end
          # if restrictions are specified, assign the value
          unless @set_restrictions.blank?
            nyucore.source_metadata.restrictions = restrictions[@set_restrictions] if restrictions.has_key?(@set_restrictions)
          end

          if nyucore.save
            Rails.logger.info("#{nyucore.pid} has been saved to Fedora")
            nyucore
          end
        end.compact
      end
      def get_records_by_prefix
        raise_runtime_error_if_no_prefix_specified
        prefix = self.class.prefix
        @resources = Nyucore.where("id:#{prefix}*")
        @resources.reject! do |r|
          r.pid !~ /^#{prefix}:.*/
        end
      end

      def delete
        get_records_by_prefix if resources.empty?
        resources.collect do |resource|
          if resource.is_a?(Resource)
            nyucore = Nyucore.find(pid: resource.pid).first
            nyucore.destroy if nyucore
            nyucore
          elsif resource.is_a?(Nyucore)
            resource.destroy 
            resource
          else
            raise RuntimeError.new("Expecting #{resource} to be of type Nyucore or Resource")
          end
        end
      end

      private

      def restrictions
        @restrictions ||= begin
                            file = File.join(Rails.root, RESTRICT_FILENAME)

                            unless File.exists?(file)
                              raise "You are missing an access rights configuration file: #{filename}."
                            end

                            begin
                              yml = YAML.load_file(file)
                            rescue
                              raise("#{filename} was found, but could not be parsed.")
                            end

                            yml["type"]
                          end
      end

      def add_edit_groups(*args)
        nyucore = args.last
        nyucore.set_edit_groups(editors, []) unless editors.empty?
      end

      def add_resource_set(*args)
        nyucore = args.last
        nyucore.source_metadata.resource_set = name
      end

      def name
        @name ||= self.class.name.demodulize.underscore
      end

      def before_load_methods
        @before_load_methods ||= begin
          before_loads.collect do |before_load|
            method(before_load)
          end
        end
      end
      def raise_runtime_error_if_no_prefix_specified
        if self.class.prefix.blank?
          raise RuntimeError.new("No prefix has been specified for the class #{self.class.name}")
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
