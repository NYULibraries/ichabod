require 'spec_helper'
module Ichabod
  module ResourceSet
    module SourceReaders
      describe ArchiveItAccwReader do
        let(:endpoint_url) { 'https://archive-it.org' }
        let(:path) { '/collections/4049.json' }
        let(:collection_code) { 'archive_it_accw' }
        let(:resource_set) { mock_resource_set }
        before do
          allow(resource_set).to receive(:endpoint_url) { endpoint_url }
          allow(resource_set).to receive(:path) { path }
          allow(resource_set).to receive(:collection_code) { collection_code }
        end
        subject(:reader) { ArchiveItAccwReader.new(resource_set) }
        describe '#resource_set' do
          subject { reader.resource_set }
          it { should eq resource_set }
        end
        describe '#read', vcr: {cassette_name: 'resource sets/archive_it_accw'} do
          subject(:read) { reader.read }
          it { should be_an Array }
          it { should_not be_empty }
          its(:size) { should eq 144 }
          it 'should include only ResourceSet::Resources' do
            subject.each do |resource|
              expect(resource).to be_a ResourceSet::Resource
            end
          end
          describe 'the first record' do
            subject { read.first }
            its(:prefix) { should eq resource_set.prefix }
            its(:identifier) { should eq '261ca521648b64ea12e077a254b58553' }
            its(:available) { should eq 'https://wayback.archive-it.org/4049/*/http://LouisKarchin.com/' }
            its(:version) { should eq 'http://LouisKarchin.com/' }
            its(:series) { should be_nil }
            its(:title) { should match 'LouisKarchin.com' }
          end
        end
      end
    end
  end
end
