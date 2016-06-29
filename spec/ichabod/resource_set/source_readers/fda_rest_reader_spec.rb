require 'spec_helper'
module Ichabod
  module ResourceSet
    module SourceReaders
      describe FdaCollectionRestReader do
        let(:fda_collection_id) { '520' }
        let(:fda_rest_url) { 'https://archive.nyu.edu/rest' }
        let(:fda_rest_user) { 'username' }
        let(:fda_rest_pass) { 'password' }
        let(:resource_set) { mock_resource_set }
        before do
          allow(resource_set).to receive(:fda_collection_id) { fda_collection_id }
          allow(resource_set).to receive(:fda_rest_url) { fda_rest_url }
          allow(resource_set).to receive(:fda_rest_user) { fda_rest_user }
          allow(resource_set).to receive(:fda_rest_pass) { fda_rest_pass }
        end
        subject(:reader) { FdaCollectionRestReader.new(resource_set) }
        describe '#resource_set' do
          subject { reader.resource_set }
          it { should eq resource_set }
        end
        describe '#read', vcr: {cassette_name: 'resource sets/fda vinopal collection'} do
          subject(:read) { reader.read }
          it { should be_an Array }
          it { should_not be_empty }
          it 'should include only ResourceSet::Resources' do
            subject.each do |resource|
              expect(resource).to be_a ResourceSet::Resource
            end
          end
          describe 'the first record' do
            subject { read.first }
            its(:prefix) { should eq resource_set.prefix }
            its(:format) { should include 'application/pdf' }
            its(:available) { should include 'http://hdl.handle.net/2451/27794' }
            its(:title) { should include 'Using Confluence for Project Portfolio Management at New York University' }
            its(:type) { should include 'Presentation'}
            its(:subject) { should match_array ['Project Management','Digital Library','Project Portfolio Management','Software','Wikis']}
          end
        end
      end
    end
  end
end
