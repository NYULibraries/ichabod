module Ichabod
  module ResourceSet
    # The OptionsInterpreter is a small class that allow us to pass an options
    # argument to a ResourceSet constructor and protect us from accidently
    # Doing Bad Things to ourselves.
    #
    # The OptionsInterpreter is overly strict for now. It enforces the Ruby
    # style guide, requiring the following
    #   - Ruby 1.9 hash literal syntax {symbol: 'value'}
    #   - symbols for Hash keys
    #   - single-quoted strings for Hash values
    #   - no space after { and before } for Hashes
    #
    # Examples
    #   # Valid options
    #   options = "{filename: 'this/is/a/filename'}"
    #   # => "{filename: 'this/is/a/filename'}"
    #   options.class
    #   # => String
    #   spatial_data_repository = SpatialDataRepository.new(options)
    #   #=> #<SpatialDataRepository>
    #   # The options are valid and can be
    #   spatial_data_repository.options
    #   # => {:filename=>"this/is/a/filename"}
    #   spatial_data_repository.options.class
    #   # => Hash
    #
    #   # Invalid options
    #   options = "rm -rf *"
    #   # => "rm *"
    #   options.class
    #   # => String
    #   spatial_data_repository = SpatialDataRepository.new(options)
    #   #=> #<SpatialDataRepository>
    #   spatial_data_repository.options
    #   # => {}
    #   spatial_data_repository.options.class
    #   # => Hash
    class OptionsInterpreter
      REGEXP = /^{([a-z_][\da-z_]*: '[^']*[^\\]'(, )?)+}$/
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
