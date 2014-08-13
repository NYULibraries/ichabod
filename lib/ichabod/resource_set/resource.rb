module Ichabod
  module ResourceSet
    # Public
    class Resource

      NYUCORE_ATTRIBUTES = Nyucore.defined_attributes.keys.map(&:to_sym)

      attr_accessor :prefix
      attr_accessor *NYUCORE_ATTRIBUTES

      def initialize(attributes={})
        attributes.each_pair do |key, value|
          send("#{key}=".to_sym, value)
        end
      end

      def to_nyucore
        return @nyucore unless @nyucore.nil?
        @nyucore = Nyucore.new
        NYUCORE_ATTRIBUTES.each do |attribute|
          @nyucore.send("#{attribute}=".to_sym, send(attribute))
        end
        @nyucore
      end
    end
  end
end
