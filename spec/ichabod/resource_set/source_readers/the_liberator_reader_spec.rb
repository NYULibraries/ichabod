require 'spec_helper'
module Ichabod
  module ResourceSet
    module SourceReaders
      describe TheLiberatorReader do
        let(:endpoint_url) { 'http://discovery.dlib.nyu.edu:8080/solr3_discovery/viewer/select' }
        let(:collection_code) { 'theliberator' }
        let(:rows) { '77' }
        let(:start) { '0' }
        let(:resource_set) { mock_resource_set }
        before do
          allow(resource_set).to receive(:endpoint_url) { endpoint_url }
          allow(resource_set).to receive(:collection_code) { collection_code }
          allow(resource_set).to receive(:rows) { rows }
          allow(resource_set).to receive(:start) { start }
        end
        subject(:reader) { TheLiberatorReader.new(resource_set) }
        describe '#resource_set' do
          subject { reader.resource_set }
          it { should eq resource_set }
        end
        describe '#read', vcr: {cassette_name: 'resource sets/the_liberator'} do
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
            # http://discovery.dlib.nyu.edu:8080/solr3_discovery/viewer/select/?qf=sm_collection_code&qf=ss_handle&q=http://hdl.handle.net/2333.1/5x69pb34
            subject { read.first }
            its(:prefix) { should eq resource_set.prefix }
            its(:available) { should eq 'http://hdl.handle.net/2333.1/5x69pb34' }
            its(:citation) { should eq 'http://hdl.handle.net/2333.1/5x69pb34' }
            its(:creator) { should match_array [
                                                   'Eastman, Max, 1883-1969, ed.',
                                                   'Eastman, Crystal, 1881-1928, ed.',
                                                   'Watts, Theodore F., ctb.',
                                               ]
            }
            its(:data_provider) { should match_array ['tamwag'] }
            its(:date) { should eq 'August 1921' }
            # TODO: have someone confirm this.
            # For now, using http://www.chicagomanualofstyle.org/16/ch14/ch14_sec180.html,
            # which uses: "[journal] [volume - in Arabic numerals], [issue, optional] ([date])".
            # In our record, that would be:
            #     * Journal: hardcoded "The Liberator", because the `ss_title` field includes the date
            #     * Volume: `sm_field_volume`
            #     * Issue: omitted, because date includes month
            #     * Date: In parentheses, `ss_publication_date_text`
            its(:description) { should eq 'The Liberator 4, (August 1921)' }
            its(:identifier) { should eq 'http://hdl.handle.net/2333.1/5x69pb34' }
            its(:language) { should eq 'en' }
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

          end
        end
      end
    end
  end
end
