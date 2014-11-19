module Ichabod
  module ResourceSet
    # Public
    class Resource
      require 'iso-639'

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
          
          value = map_language(value[0]) if key =~ /language/ and value.length > 0
          send("#{key}=".to_sym, value)
        end
      end

      def pid
        @pid ||= "#{prefix}:#{clean_identifier(pid_identifier)}"
      end

      def to_nyucore
        return @nyucore unless @nyucore.nil?
        # Use Nyucore.find(pid: pid) since Nyucore.find(pid)
        # raises an error if it's not found
        @nyucore = Nyucore.find(pid: pid).first
        @nyucore ||= Nyucore.new(pid: pid)
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

      def map_language(lan)
        language = ""
        iso = ISO_639.search(lan)
        len = iso.length
        counter = 0
        #doing while loop in case search function returns multiple values
        #returns array of arrays
        while counter < len 
          iso[counter].each{|l|
            if lan == l
              #the ISO English equivalent of the code or the language
              #always in the 4th position of the array
              language = iso[counter][3] 
            end
          }
          counter = counter + 1
        end
        language 
      end

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
