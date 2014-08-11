require 'spec_helper'
require 'cancan/matchers'
require Rails.root.join('app','models','ability.rb')

describe Ability do

  describe Nyucore, vcr: { cassette_name: "nyucore query permissions" } do
    let(:record) { create(:gis_record) }
    let(:user) { create(:user) }
    subject(:ability) { Ability.new(user) }

    context "non gis cataloger user can not perform CRUD actions on the GIS collection" do
      it { should_not be_able_to(:new, Nyucore) }
      it { should_not be_able_to(:create, Nyucore) }
      it { should_not be_able_to(:read, record) }
      it { should_not be_able_to(:edit, record) }
      it { should_not be_able_to(:update, record) }
      it { should_not be_able_to(:destroy, record) }
    end
    context "gis cataloger can perform CRUD actions on the GIS collection" do
      let(:user) { create(:gis_cataloger) }
      it { should be_able_to(:new, Nyucore) }
      it { should be_able_to(:create, Nyucore) }
      it { should be_able_to(:read, record) }
      it { should be_able_to(:edit, record) }
      it { should be_able_to(:update, record) }
      it { should be_able_to(:destroy, record) }
    end
  end
end
