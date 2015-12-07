require 'spec_helper'
module Ichabod
  module ResourceSet
    module SourceReaders
      describe FabReader do
        let(:endpoint_url) { 'https://specialcollections.library.nyu.edu/search/catalog.json' }
        let(:query) { "?f%5Bcollection_sim%5D%5B%5D=David+Wojnarowicz+Papers&f%5Bdao_sim%5D%5B%5D=Online+Access&f%5Bformat_sim%5D%5B%5D=Archival+Object" }
        let(:collection_code) { 'woj' }
        let(:resource_set) { mock_resource_set }
        before do
          allow(resource_set).to receive(:endpoint_url) { endpoint_url }
          allow(resource_set).to receive(:query) { query }
          allow(resource_set).to receive(:collection_code) { collection_code }
        end
        subject(:reader) { FabReader.new(resource_set) }
        describe '#resource_set' do
          subject { reader.resource_set }
          it { should eq resource_set }
        end
        describe '#read', vcr: {cassette_name: 'resource sets/fab'} do
          subject(:read) { reader.read }
          it { should be_an Array }
          it { should_not be_empty }
          its(:size) { should eq 97 }
          it 'should include only ResourceSet::Resources' do
            subject.each do |resource|
              expect(resource).to be_a ResourceSet::Resource
            end
          end
          describe 'the first record' do
            subject { read.first }
            its(:prefix) { should eq resource_set.prefix }
          end
        end
      end
    end
  end
end
