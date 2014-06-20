require 'spec_helper'
require 'cancan'
require 'cancan/matchers'
require_relative '../../app/models/ability.rb'

describe Ability do

   describe Nyucore, vcr: { cassette_name: "nyucore create new" } do
     let(:record) { create(:valid_gis_record) }
     context "gis cataloger can perform CRUD actions on the GIS collection" do
        let(:user) { create(:gis_cataloger) }
        subject(:ability) { Ability.new(user) }
        it { should be_able_to(:crud, record) }
     end
     context "non gis cataloger user can not perform CRUD actions on the GIS collection" do
        let(:user) { create(:user) }
        subject(:ability) { Ability.new(user) }
        it { should_not be_able_to(:crud, record) }
     end
   end
end
