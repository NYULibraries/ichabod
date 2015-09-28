require 'spec_helper'
require 'support/test_user_helper'

describe ApplicationController do

  describe "current_user_dev" do
    subject(:user) { controller.current_user_dev }
    it { should be_instance_of(User) }
    it { expect(user.email).to eql("user@nyu.edu") }
  end

  describe "authorize_collection" do
    subject{ controller.authorize_collection }
    context "user should be authorized to view collection when he is a site admin" do
      let(:user) { create_or_return_test_admin }
      before  { controller.stub(:current_user).and_return(user) }
      it { should be true }
    end
    context "user should not be authorized to view collection when he is not logged in" do
      let(:user) { nil }
      before  { controller.stub(:current_user).and_return(user) }
      it { should be false }
    end
    context "user should not be authorized to view collection when is not site admin or io collection admin" do
      let(:user) { create(:gis_cataloger) }
      before  { controller.stub(:current_user).and_return(user) }
      it { should be false }
    end
    context "user should be authorized to view collection when he is io collection admin" do
      let(:user) {  create(:io_cataloger) }
      before  { controller.stub(:current_user).and_return(user) }
      it { should be true }
    end
  end

end
