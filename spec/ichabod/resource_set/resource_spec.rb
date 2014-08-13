require 'spec_helper'
module Ichabod
  module ResourceSet
    describe Resource do
      subject(:resource) { create :resource }
      it { should be_a Resource }
      describe '#prefix' do
        subject { resource.prefix }
        it { should eq 'prefix' }
      end
      describe '#to_nyucore' do
        subject { resource.to_nyucore }
        it { should be_an Nyucore }
        it { should_not be_persisted }
      end
    end
  end
end
