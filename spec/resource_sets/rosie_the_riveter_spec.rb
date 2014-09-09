require 'spec_helper'
describe RosieTheRiveter do
  let(:prefix) { 'rosie' }
  let(:endpoint_url) { 'https://rosie.the.riveter' }
  let(:user) { 'user' }
  let(:password) { 'password' }
  let(:collection_code) { 'rosie' }
  let(:args) { [endpoint_url, user, password].compact }
  subject(:rosie_the_riveter) { RosieTheRiveter.new(*args) }
  it { should be_a RosieTheRiveter }
  it { should be_a Ichabod::ResourceSet::Base }
  its(:prefix) { should eq prefix }
  its(:endpoint_url) { should eq endpoint_url }
  its(:user) { should eq user }
  its(:password) { should eq password }
  its(:collection_code) { should eq collection_code }
  its(:editors) { should eq ['admin_group'] }
  its(:before_loads) { should eq [:add_edit_groups, :add_resource_set] }
  context 'when initialized without a password' do
    let(:password) { nil }
    it 'should not raise an error' do
      expect { subject }.not_to raise_error
    end
    its(:password) { should be_nil }
    context 'and initialized without a user' do
      let(:user) { nil }
      it 'should not raise an error' do
        expect { subject }.not_to raise_error
      end
      its(:user) { should be_nil }
    end
  end
  describe '.prefix' do
    subject { RosieTheRiveter.prefix }
    it { should eq prefix }
  end
  describe '.source_reader' do
    subject { RosieTheRiveter.source_reader }
    it 'should be a DLTS reader'
    it { should eq Ichabod::ResourceSet::SourceReaders::RosieTheRiveterReader }
  end
  describe '.editors' do
    subject { RosieTheRiveter.editors }
    it { should eq [:admin_group] }
  end
  describe '.before_loads' do
    subject { RosieTheRiveter.before_loads }
    it { should eq [:add_edit_groups, :add_resource_set] }
  end
end
