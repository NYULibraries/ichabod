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

      def pid
        @pid ||= "#{prefix}:#{clean_identifier(first_identifier)}"
      end

      def to_nyucore
        return @nyucore unless @nyucore.nil?
        @nyucore = Nyucore.new(pid: pid)
        NYUCORE_ATTRIBUTES.each do |attribute|
          @nyucore.send("#{attribute}=".to_sym, send(attribute))
        end
        @nyucore
      end

      private
      def clean_identifier(identifier)
        identifier.gsub(/[\.\/\\]/, '-').gsub('http://', '')
      end

      def first_identifier
        @first_identifier ||= begin
          if identifier.is_a? Array
            identifier.first
          else
            identifier
          end
        end
      end
    end
  end
end
