require 'spec_helper'
module Ichabod
  module ResourceSet
    module SourceReaders
      describe FabReader do
        let(:data_params) { {"f[collection_sim][]" => 'David Wojnarowicz Papers', "f[dao_sim][]" => 'Online Access',"f[format_sim][]"     => 'Archival Object'} }
        let(:collection_code) { 'woj' }
        let(:page) { nil }
        let(:resource_set) { mock_resource_set }
        before do
          allow(resource_set).to receive(:data_params) { data_params }
          allow(resource_set).to receive(:page)  { page }
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
