module SpecTestHelper
  def create_or_return_test_admin
    @user ||= create(:admin)
  end

  def create_or_return_test_collection
    @collection_test ||= create(:collection, :title=>'Test Collection')
  end
  
end
