require 'spec_helper'
require 'cancan'
require 'cancan/matchers'
require_relative '../../app/models/ability.rb'

describe Ability do

  describe Nyucore, vcr: { cassette_name: "nyucore query permissions" } do
    let(:record) { create(:valid_gis_record) }
    let(:user) { create(:gis_cataloger) }
    subject(:ability) { Ability.new(user) }

    it { should be_able_to(:read, record) }

    context "gis cataloger can perform CRUD actions on the GIS collection" do
      it { should be_able_to(:edit, record) }
      it { should be_able_to(:update, record) }
      it { should be_able_to(:destroy, record) }
    end
    context "non gis cataloger user can not perform CRUD actions on the GIS collection" do
      let(:user) { create(:user) }
      it { should_not be_able_to(:edit, record) }
      it { should_not be_able_to(:update, record) }
      it { should_not be_able_to(:destroy, record) }
    end
  end
end
