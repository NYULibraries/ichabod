class RosieTheRiveter < Ichabod::ResourceSet::Base
  self.prefix = 'rosie'

  attr_reader :url

  def initialize(*args)
    @url = args.shift
    super
  end
end
