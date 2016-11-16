module Ichabod
  module ResourceSet
    # Public
    class Resource
      include MetadataFields
      require 'iso-639'

      HANDLE_REGEXP = /^http:\/\/hdl\.handle\.net/
      URL_REGEXP = /^https?:\/\//

      #module METADATA_FIELDS is in app/model/concerns
      NYUCORE_ATTRIBUTES = MetadataFields.process_metadata_field_names
      attr_accessor :prefix
      attr_writer :pid_identifier
      attr_accessor(*NYUCORE_ATTRIBUTES)

      def initialize(attributes={})
        attributes.each_pair do |key, value|
          #mapping iso code to language which is then faceted
          value = map_language(value) if key =~ /language/ and value.length > 0
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

      #returns one occurrence of language
      def map_language(value)
        #changing to a string value since I am returning only one value
        language = case
           when value.is_a?(Array)  then value
           when value.is_a?(String) then [value]
           else raise ArgumentError.new("Expecting #{value} to be an Array or String")
           end

        iso_lang_code = ""

        language.each{|lan|
          lan.downcase!
          iso = ISO_639.search(lan)
          #returns an array of arrays
          iso.each_index{|la|
            iso[la].each{|l|
              #if code is found in language array of arrays
              if l == lan
                #the ISO English equivalent of the code or the language
                #always in the 4th position of the array
                iso_lang_code = iso[la][3]
                break
              end
            }

          }
          break if !iso_lang_code.empty?
        }
        iso_lang_code

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
