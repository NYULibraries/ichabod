module TestUserHelper
  def create_or_return_test_admin
    @user ||= create(:admin)
  end
end
