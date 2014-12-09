require 'spec_helper'
module Ichabod
  module ResourceSet
    module SourceReaders
      describe NyuPressOpenAccessBookReader do
        let(:endpoint_url) { 'http://discovery.dlib.nyu.edu:8080/solr3_discovery/nyupress/select' }
        let(:collection_code) { 'nyupress' }
        let(:rows) { '65' }
        let(:start) { '0' }
        let(:resource_set) { mock_resource_set }
        before do
          allow(resource_set).to receive(:endpoint_url) { endpoint_url }
          allow(resource_set).to receive(:collection_code) { collection_code }
          allow(resource_set).to receive(:rows) { rows }
          allow(resource_set).to receive(:start) { start }
        end
        subject(:reader) { NyuPressOpenAccessBookReader.new(resource_set) }
        describe '#resource_set' do
          subject { reader.resource_set }
          it { should eq resource_set }
        end
        describe '#read', vcr: {cassette_name: 'resource sets/nyu_press_books'} do
          subject(:read) { reader.read }
          it { should be_an Array }
          it { should_not be_empty }
          its(:size) { should eq 65 }
          it 'should include only ResourceSet::Resources' do
            subject.each do |resource|
              expect(resource).to be_a ResourceSet::Resource
            end
          end
          describe 'the first record' do
            subject { read.first }
            its(:prefix) { should eq resource_set.prefix }
            its(:identifier) { should eq '9780814706404' }
            its(:title) { should eq 'Negrophobia and Reasonable Racism' }
            its(:available) { should eq 'http://hdl.handle.net/2333.1/37pvmfhh' }
            its(:citation) { should eq 'http://hdl.handle.net/2333.1/37pvmfhh' }
            its(:type) { should eq 'Text' }
            its(:language) { should eq 'English' }
          end
        end
      end
    end
  end
end
