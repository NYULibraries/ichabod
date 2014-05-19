require 'spec_helper'

describe ApplicationController do

  describe "current_user_dev" do
    subject(:user) { controller.current_user_dev }
    it { should be_instance_of(User) }
    it { expect(user.email).to eql("user@nyu.edu") }
  end

end
