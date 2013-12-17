class UserSessionsController < ApplicationController
  include Authpds::Controllers::AuthpdsSessionsController
  
  # GET /validate
  def validate
    # Only create a new one if it doesn't exist
    @user_session ||= UserSession.create(params[:user_session])
    redirect_to root_url
  end

end
