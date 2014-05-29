## Two strategies for mocking login

# 1) Open up ApplicationController and set the current_user method to a dummy user
# ApplicationController.class_eval do
#   def current_user
#     @current_user ||= FactoryGirl.build(:user)
#   end
# end

# 2) Open up UserSession and set pds_handle to a handle which we have previously recorded a VHS for
UserSession.class_eval do

  # Override pds_handle to use ENV['PDS_HANDLE'] if it's available
  def pds_handle
    # Set PDS handle in an environment variable if you want to
    # override super, e.g. ENV['PDS_HANDLE'] = 'GIS_Cataloger'
    pds_handle_lambda.call || super
  end

  # Read PDS handle from an evironment variable, PDS_HANDLE
  # It will return nil if ENV['PDS_HANDLE'] is not set
  def pds_handle_lambda
    -> { ENV['PDS_HANDLE'] }
  end
  private :pds_handle_lambda
end
