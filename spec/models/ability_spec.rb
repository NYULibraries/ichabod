require 'spec_helper'
require 'cancan'
require 'cancan/matchers'
require_relative '../../app/models/ability.rb'
require 'pp'

describe Ability do

 describe Nyucore, vcr: { cassette_name: "nyucore create new" } do
   let(:record) { create(:valid_nyucore) }
   #let(:user1) { build(:user, username: "gis") }
   let(:user1) { create(:user) }
    puts :user1.to_yaml
   let(:ability) { Ability.new(user1) }
   it "should be able to manage a record" do
      ability.should be_able_to(:manage, record)
    end
 end

end
