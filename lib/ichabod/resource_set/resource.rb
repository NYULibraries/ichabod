module Ichabod
  module ResourceSet
    # Public
    class Resource

      HANDLE_REGEXP = /^http:\/\/hdl\.handle\.net/
      URL_REGEXP = /^https?:\/\//

      NYUCORE_ATTRIBUTES = [:identifier, :addinfolink, :addinfotext, :available,
        :citation, :title, :creator, :type, :publisher, :description, :edition,
        :date, :format, :language, :relation, :rights, :subject, :series,
        :version]

      attr_accessor :prefix
      attr_writer :pid_identifier
      attr_accessor(*NYUCORE_ATTRIBUTES)

      def initialize(attributes={})
        attributes.each_pair do |key, value|
          send("#{key}=".to_sym, value)
        end
      end

      def pid
        @pid ||= "#{prefix}:#{clean_identifier(pid_identifier)}"
      end

      def to_nyucore
        return @nyucore unless @nyucore.nil?
        @nyucore = Nyucore.new(pid: pid)
        NYUCORE_ATTRIBUTES.each do |attribute|
          @nyucore.send("#{attribute}=".to_sym, send(attribute))
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
        identifier.gsub(URL_REGEXP, '').gsub(/[\.\/\\\?=]/, '-')
      end

      def pid_identifier
        @pid_identifier ||= begin
          if identifier.is_a? Array
            # First, try to find a handle
            if identifier.any? { |id| HANDLE_REGEXP === id }
              identifier.find { |id| HANDLE_REGEXP === id }
            # Next, try to find any URL
            elsif identifier.any? { |id| URL_REGEXP === id }
              identifier.find { |id| URL_REGEXP === id }
            # If we can't find a URL, grab the first one
            else
              identifier.first
            end
          else
            identifier
          end
        end
      end
    end
  end
end
