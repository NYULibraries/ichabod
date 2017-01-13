require 'spec_helper'
module Ichabod
  module ResourceSet
    module SourceReaders
      describe FreedomReader do
        let(:endpoint_url) { 'http://discovery.dlib.nyu.edu:8080/solr3_discovery/viewer/select' }
        let(:collection_code) { 'freedom' }
        let(:rows) { '45' }
        let(:start) { '0' }
        let(:resource_set) { mock_resource_set }
        before do
          allow(resource_set).to receive(:endpoint_url) { endpoint_url }
          allow(resource_set).to receive(:collection_code) { collection_code }
          allow(resource_set).to receive(:rows) { rows }
          allow(resource_set).to receive(:start) { start }
        end
        subject(:reader) { FreedomReader.new(resource_set) }
        describe '#resource_set' do
          subject { reader.resource_set }
          it { should eq resource_set }
        end
        describe '#read', vcr: {cassette_name: 'resource sets/freedom'} do
          subject(:read) { reader.read }
          it { should be_an Array }
          it { should_not be_empty }
          its(:size) { should eq 45 }
          it 'should include only ResourceSet::Resources' do
            subject.each do |resource|
              expect(resource).to be_a ResourceSet::Resource
            end
          end
          describe 'the first record' do
            # http://discovery.dlib.nyu.edu:8080/solr3_discovery/viewer/select/?fq=http://hdl.handle.net/2333.1/5x69pb34
            subject { read.first }
            its(:prefix) { should eq resource_set.prefix }
            its(:available) { should eq 'http://hdl.handle.net/2333.1/djh9w50t' }
            its(:creator) { should match_array [
                                                   'Robeson, Paul, 1898-1976, editorial director.',
                                                   'Burnham, Louis E., editor.',
                                                   'Robeson, PaulJr, 1927-2014, contributor.'
                                                   ]
            }
            its(:data_provider) { should eq FreedomReader::DATA_PROVIDER }
            its(:date) { should eq "1951-01-01T00:00:00Z" }
            its(:description) { should eq 'Freedom 1, (January 1951)' }
            its(:identifier) { should eq 'http://hdl.handle.net/2333.1/djh9w50t' }
            its(:language) { should eq 'English' }
            its(:publisher) { should match_array ['Freedom Associates'] }
            its(:series) { should match_array ['1'] }
            its(:subject) { should match_array [
                                                   'African Americans -- Civil rights -- United States -- Newspapers',
                                                   'African Americans -- Economic conditions -- Newspapers',
                                                   'Civil rights -- United States -- Newspapers',
                                                   'Civil rights and socialism -- United States -- Newspapers',
                                                   'African Americans -- Civil rights',
                                                   'African Americans -- Economic conditions',
                                                   'Race relations',
                                                   'United States -- Race relations -- Newspapers',
                                                   'United States'
                                               ]
            }
            its(:title) { should eq 'Freedom, January 1951' }
            its(:type) { should eq FreedomReader::FORMAT }
          end
        end
      end
    end
  end
end
