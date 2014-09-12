module Ichabod
  class DataLoader
    attr_reader :name, :args, :resource_set

    def initialize(name, *args)
      @name = name
      @args = args
      # Use :camelize to get the CamelCase version of the string
      #   "lib_guides".camelize
      #   # => "LibGuides"
      # We don't use :classify since it makes the class name singular
      #   "lib_guides".classify
      #   # => "LibGuide"
      klass = name.camelize.safe_constantize
      if klass.nil?
        raise ArgumentError.new("Expecting #{name} to be a class name")
      end
      @resource_set = klass.new(*args)
      unless resource_set.is_a? ResourceSet::Base
        raise ArgumentError.new("Expecting #{resource_set} to be a ResourceSet")
      end
    end

    def read
      resource_set.read_from_source
    end

    def load
      @records = resource_set.load
    end

    def delete
      @records = resource_set.delete
    end
  end
end
