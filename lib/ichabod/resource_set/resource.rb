module Ichabod
  module ResourceSet
    # Public
    class Resource

      NYUCORE_ATTRIBUTES = [:identifier, :addinfolink, :addinfotext, :available,
        :citation, :title, :creator, :type, :publisher, :description, :edition,
        :date, :format, :language, :relation, :rights, :subject, :series,
        :version]

      attr_accessor :prefix
      attr_accessor(*NYUCORE_ATTRIBUTES)

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
          @nyucore.source_metadata.send("#{attribute}=".to_sym, send(attribute))
        end
        @nyucore
      end

      def to_s
        "pid: #{pid}\n" +
        NYUCORE_ATTRIBUTES.map do |attribute|
          value = send(attribute)
          if value.present?
            if value.is_a? Array
              "#{attribute}: #{value.join('; ')}"
            else
              value
            end
          end
        end.compact.join("\n") + "\n"
      end

      private
      def clean_identifier(identifier)
        identifier.gsub('http://', '').gsub(/[\.\/\\]/, '-')
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
