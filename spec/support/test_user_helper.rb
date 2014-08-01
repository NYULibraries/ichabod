
module SpecTestHelper

  def create_or_return_test_admin
    @user ||= create(:admin)
  end
  
end


RSpec.configure do |config|
  config.include SpecTestHelper, :type => :controller
end