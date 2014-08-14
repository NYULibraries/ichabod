module Ichabod
  class DataLoader
    attr_reader :name, :options, :resource_set

    def initialize(name, options={})
      @name = name
      @options = options
      klass = name.classify.safe_constantize
      if klass.nil?
        raise ArgumentError.new("Expecting #{@resource_set_name} to be a class name")
      end
      @resource_set = klass.new(options)
      unless resource_set.is_a? ResourceSet::Base
        raise ArgumentError.new("Expecting #{@resource_set} to be a ResourceSet")
      end
    end

    def read
      resource_set.read_from_source
    end

    def load
      @records = resource_set.create
    end

    def delete
      @records = resource_set.delete
    end

    def records
      @records ||= []
    end
  end
end
