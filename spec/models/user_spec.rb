require 'spec_helper'

describe User do

  let(:user) { create(:user) }

  subject { User.new }
  it { should be_a User }

  describe "#user_attributes" do
    subject { user.user_attributes }
    it { should be_instance_of(Hash) }
  end

  describe "#to_s" do
    subject { user.to_s }
    it { should eql(user.email) }
  end

  describe "#user_key" do
    subject { user.user_key }
    it { should eql(user.username) }
  end

  describe ".find_by_user_key" do
    subject { User.find_by_user_key(user.user_key) }
    it { should eql(user) }
  end

  describe "#admin?" do
    subject { user.admin? }
    it { should be_false }
  end

end
