require 'spec_helper'
describe VinopalFdaCollection do
  let(:prefix) { 'fda' }
  let(:fda_rest_url) { 'https://archive.nyu.edu/rest' }
  let(:fda_rest_user) { 'username' }
  let(:fda_rest_pass) { 'password' }
  let(:args) { [fda_rest_url, fda_rest_user, fda_rest_pass].compact }
  ## Commenting this out temporarily because collection does not exist
  ## Still don't understand why this should error
  ## Trying it out
  #subject(:vinopal_fda_collection) { VinopalFdaCollection.new(*args) }

  it { should be_a VinopalFdaCollection }
  it { should be_a Ichabod::ResourceSet::Base }

  its(:editors) { should eq ['admin_group', 'fda_cataloger'] }
  its(:before_loads) { should eq [:add_edit_groups, :add_resource_set] }

  describe '.prefix' do
    subject { VinopalFdaCollection.prefix }
    it { should eq prefix }
  end
  describe '.source_reader' do
    subject { VinopalFdaCollection.source_reader }
    it { should eq Ichabod::ResourceSet::SourceReaders::FdaCollectionRestReader }
  end
  describe '.editors' do
    subject { VinopalFdaCollection.editors }
    it { should eq [:admin_group, :fda_cataloger] }
  end
  describe '.before_loads' do
    subject { VinopalFdaCollection.before_loads }
    it { should eq [:add_edit_groups, :add_resource_set] }
  end
end
