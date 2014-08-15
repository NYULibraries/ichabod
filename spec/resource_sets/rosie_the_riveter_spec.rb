require 'spec_helper'
describe RosieTheRiveter do
  let(:prefix) { 'rosie' }
  let(:url) { 'https://rosie.the.riveter' }
  subject(:rosie_the_riveter) { RosieTheRiveter.new(url) }
  it { should be_a RosieTheRiveter }
  it { should be_a Ichabod::ResourceSet::Base }
  its(:url) { should eq url }
  its(:prefix) { should eq prefix }
  its(:editors) { should eq ['admin_group'] }
  its(:before_creates) { should eq [:add_edit_groups] }
  describe '.prefix' do
    subject { RosieTheRiveter.prefix }
    it { should eq prefix }
  end
  describe '.source_reader' do
    subject { RosieTheRiveter.source_reader }
    it 'should be a DLTS reader'
  end
  describe '.editors' do
    subject { RosieTheRiveter.editors }
    it { should eq [:admin_group] }
  end
  describe '.before_creates' do
    subject { RosieTheRiveter.before_creates }
    it { should eq [:add_edit_groups] }
  end
end
