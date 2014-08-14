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

    def load
      @records = resource_set.create
    end

    def delete
      @records = resource_set.delete
    end

    def records
      @records ||= []
    end

    def field_stats
      records.each do |record|
        Nyucore.defined_attributes.keys.map(&:to_sym).each do |attribute|
          value = record.send(attribute)
          p value unless value.blank?
        end
      end
      records.count
    end
  end
end
