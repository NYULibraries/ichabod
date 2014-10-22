require 'spec_helper'
module Ichabod
  module ResourceSet
    module SourceReaders
      describe OaiDcHttpReader do
        let(:endpoint_url) { 'http://archive.nyu.edu/request' }
        let(:set_handle) { 'hdl_2451_33605' }
        let(:collection_code) { 'fda' }
        let(:load_number_of_records) { 5 }
        let(:resource_set) { mock_resource_set }
        before do
          allow(resource_set).to receive(:endpoint_url) { endpoint_url }
          allow(resource_set).to receive(:set_handle) { set_handle }
          allow(resource_set).to receive(:collection_code) { collection_code }
          allow(resource_set).to receive(:load_number_of_records) { load_number_of_records }
        end
        subject(:oai_dc_http_reader) { OaiDcHttpReader.new(resource_set) }
        it { should be_a OaiDcHttpReader }
        it { should be_a ResourceSet::SourceReader }
        describe '#resource_set' do
          subject { oai_dc_http_reader.resource_set }
          it { should eq resource_set }
        end
        describe '#read', vcr: {cassette_name: 'resource sets/fda_ngo'}  do
          subject(:read) { oai_dc_http_reader.read }
          it { should be_an Array }
          it { should_not be_empty }
          its(:size) { should eq 5 }
          it 'should include only ResourceSet::Resources' do
            subject.each do |resource|
              expect(resource).to be_a ResourceSet::Resource
            end
          end
          describe 'the first record' do
            subject { read.first }
            context 'when first 5 records were loaded from Asian NGO collection' do
              its(:prefix) { should eq resource_set.prefix }
              its(:identifier) { should eql ['http://www.undp.org/content/dam/india/docs/hijras_transgender_in_india_hiv_human_rights_and_social_exclusion.pdf', 'http://hdl.handle.net/2451/33612'] }
              its(:title) { should include 'Hijras/transgender women in India: HIV, human rights and social exclusion' }
              its(:creator) { should eql ['Chakrapani, Venkatesan', 'United Nations Development Programme (UNDP), India'] }
              its(:publisher) { should eql ['United Nations Development Programme (UNDP), India', '[New Delhi]'] }
              its(:subject) { should eql ['LGBT studies', 'Gender identity', 'Sexuality', 'Sexual orientation', 'Social conditions', 'Social structure', 'Sexually transmitted diseases', 'AIDS', 'Gender discrimination'] }
            end
          end
        end
      end
    end
  end
end
