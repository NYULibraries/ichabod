module Ichabod
  module ResourceSet
    class OptionsInterpreter
      REGEXP = /^{[a-z_]+: '[^']*[^\\]'}$/
      attr_reader :candidate

      def initialize(candidate)
        unless candidate.is_a?(String)
          raise ArgumentError.new("Expecting #{candidate} to be a String")
        end
        @candidate = candidate
      end

      def valid?
        REGEXP === candidate
      end

      def interpret
        @interpreted ||= (valid?) ? eval(candidate) : {}
      end
    end
  end
end
