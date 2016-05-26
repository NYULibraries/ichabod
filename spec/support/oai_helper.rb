module OaiHelper
  include Rack::Test::Methods

  def app
    Rails.application
  end
end

RSpec.configure do |config|
  config.include OaiHelper, :type=>:oai #apply to all spec for oai folder
end