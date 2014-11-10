require 'spec_helper'
module Ichabod
  module ResourceSet
    module SourceReaders
      describe VoiceReader do
        let(:endpoint_url) { 'http://discovery.dlib.nyu.edu:8080/solr3_discovery/core0/select' }
        let(:collection_code) { 'beard' }
        let(:resource_set) { mock_resource_set }
        before do
          allow(resource_set).to receive(:endpoint_url) { endpoint_url }
          allow(resource_set).to receive(:collection_code) { collection_code }
        end
        subject(:reader) { VoiceReader.new(resource_set) }
        describe '#resource_set' do
          subject { reader.resource_set }
          it { should eq resource_set }
        end
        describe '#read', vcr: {cassette_name: 'resource sets/voices'} do
          subject(:read) { reader.read }
          it { should be_an Array }
          it { should_not be_empty }
          its(:size) { should eq 48 }
          it 'should include only ResourceSet::Resources' do
            subject.each do |resource|
              expect(resource).to be_a ResourceSet::Resource
            end
          end
          
        end
      end
    end
  end
end
