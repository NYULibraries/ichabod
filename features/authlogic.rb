## Two strategies for mocking login

# 1) Open up ApplicationController and set the current_user method to a dummy user
# ApplicationController.class_eval do
#   def current_user
#     @current_user ||= User.new(:email => "user@nyu.edu", :firstname => "Ptolemy")
#   end
# end

# 2) Open up UserSession and set pds_handle to a handle which we have previously recorded a VHS for
# UserSession.class_eval do
#   def pds_handle
#     # Hardcoded now but need to figure out how make it read from an env var
#     ENV["PDS_HANDLE"] || super
#     # "GIS_Cataloger"
#   end
# end
