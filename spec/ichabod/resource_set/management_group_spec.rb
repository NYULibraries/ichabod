require 'spec_helper'
module Ichabod
  module ResourceSet
    describe ManagementGroup do
      let(:owner) { build(:user) }
      let(:members) { [build(:user), build(:user)] }
      subject(:management_group) do
        ResourceSet::ManagementGroup.new(owner, *members)
      end
      it { should be_a ResourceSet::ManagementGroup }
      describe '#owner' do
        subject { management_group.owner }
        it { should eq owner }
      end
      describe '#members' do
        subject { management_group.members }
        it { should eq [owner, *members] }
      end
      context 'when initialized with an owner argument that is not a User' do
        let(:owner) { 'invalid' }
        it 'should raise an ArgumentError' do
          expect { subject }.to raise_error ArgumentError
        end
      end
      context 'when initialized with an owner argument that is a User' do
        context 'but the members are not all Users' do
          let(:members) { [build(:user), 'invalid'] }
          it 'should raise an ArgumentError' do
            expect { subject }.to raise_error ArgumentError
          end
        end
      end
    end
  end
end
