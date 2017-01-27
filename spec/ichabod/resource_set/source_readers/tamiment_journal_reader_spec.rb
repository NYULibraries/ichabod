require 'spec_helper'
module Ichabod
  module ResourceSet
    module SourceReaders

      # Freedom collection
      describe TamimentJournalReader do
        let(:endpoint_url) { 'http://discovery.dlib.nyu.edu:8080/solr3_discovery/viewer/select' }
        let(:collection_code) { 'fdm' }
        let(:journal) { 'Freedom' }
        let(:rows) { '45' }
        let(:start) { '0' }
        let(:resource_set) { mock_resource_set }
        before do
          allow(resource_set).to receive(:endpoint_url) { endpoint_url }
          allow(resource_set).to receive(:collection_code) { collection_code }
          allow(resource_set).to receive(:journal) { journal }
          allow(resource_set).to receive(:rows) { rows }
          allow(resource_set).to receive(:start) { start }
        end
        subject(:reader) { TamimentJournalReader.new(resource_set) }
        describe '#resource_set' do
          subject { reader.resource_set }
          it { should eq resource_set }
        end
        describe '#read', vcr: {cassette_name: 'resource sets/tamiment journal'} do
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
            # http://http://discovery.dlib.nyu.edu:8080/solr3_discovery/viewer/select/?qf=id&q=705lna/node/13974
            subject { read.first }
            its(:prefix) { should eq resource_set.prefix }
            its(:available) { should eq 'http://hdl.handle.net/2333.1/j9kd55h3' }
            # Typo of "PaulJr" is in the Solr record.
            its(:creator) { should match_array [
                                                   'Robeson, Paul, 1898-1976, editorial director.',
                                                   'Burnham, Louis E., editor.',
                                                   'Robeson, PaulJr, 1927-2014, contributor.'
                                                   ]
            }
            its(:data_provider) { should eq TamimentJournalReader::DATA_PROVIDER }
            its(:date) { should eq "1950-11-01T00:00:00Z" }
            its(:description) { should eq 'Freedom, (November 1950)' }
            its(:identifier) { should eq 'http://hdl.handle.net/2333.1/j9kd55h3' }
            its(:language) { should eq 'English' }
            its(:publisher) { should match_array ['Freedom Associates'] }
            # The first record does not have a series number.  Subsequent records
            # do.
            its(:series) { should be_nil }
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
            its(:title) { should eq 'Freedom, November 1950' }
            its(:type) { should eq TamimentJournalReader::FORMAT }
          end
        end
      end

      # The Liberator collection
      describe TamimentJournalReader do
        let(:endpoint_url) { 'http://discovery.dlib.nyu.edu:8080/solr3_discovery/viewer/select' }
        let(:collection_code) { 'theliberator' }
        let(:journal) { 'The Liberator' }
        let(:rows) { '77' }
        let(:start) { '0' }
        let(:resource_set) { mock_resource_set }
        before do
          allow(resource_set).to receive(:endpoint_url) { endpoint_url }
          allow(resource_set).to receive(:collection_code) { collection_code }
          allow(resource_set).to receive(:journal) { journal }
          allow(resource_set).to receive(:rows) { rows }
          allow(resource_set).to receive(:start) { start }
        end
        subject(:reader) { TamimentJournalReader.new(resource_set) }
        describe '#resource_set' do
          subject { reader.resource_set }
          it { should eq resource_set }
        end
        describe '#read', vcr: {cassette_name: 'resource sets/tamiment journal'} do
          subject(:read) { reader.read }
          it { should be_an Array }
          it { should_not be_empty }
          its(:size) { should eq 77 }
          it 'should include only ResourceSet::Resources' do
            subject.each do |resource|
              expect(resource).to be_a ResourceSet::Resource
            end
          end
          describe 'the first record' do
            # http://discovery.dlib.nyu.edu:8080/solr3_discovery/viewer/select/?fq=http://hdl.handle.net/2333.1/5x69pb34
            subject { read.first }
            its(:prefix) { should eq resource_set.prefix }
            its(:available) { should eq 'http://hdl.handle.net/2333.1/5x69pb34' }
            its(:creator) { should match_array [
                                                   'Eastman, Max, 1883-1969, ed.',
                                                   'Eastman, Crystal, 1881-1928, ed.',
                                                   'Watts, Theodore F., ctb.',
                                               ]
            }
            its(:data_provider) { should eq TamimentJournalReader::DATA_PROVIDER }
            its(:date) { should eq "1921-08-01T00:00:00Z" }
            its(:description) { should eq 'The Liberator 4, (August 1921)' }
            its(:identifier) { should eq 'http://hdl.handle.net/2333.1/5x69pb34' }
            its(:language) { should eq 'English' }
            its(:publisher) { should match_array ['Liberator Publishing Co.'] }
            its(:series) { should match_array ['4'] }
            its(:subject) { should match_array [
                                                   'Socialism -- Periodicals',
                                                   'Socialism -- United States -- Periodicals',
                                                   'Communism -- Periodicals',
                                                   'Communism -- United States -- Periodicals',
                                               ]
            }
            its(:title) { should eq 'The Liberator, August 1921' }
            its(:type) { should eq TamimentJournalReader::FORMAT }
          end
        end
      end

    end
  end
end
