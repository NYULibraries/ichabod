require 'spec_helper'

describe UserSessionsController, :type => :controller do

  describe "GET /validate" do
    it "should create a new user session" do
      get :validate, user_session: { username: "dev123" }
      expect(assigns(:user_session)).to_not be_nil
      expect(assigns(:user_session).username).to eql("dev123")
      expect(response).to redirect_to root_url
    end
  end

end
