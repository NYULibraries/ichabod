require 'spec_helper'
module Ichabod
  module ResourceSet
    module SourceReaders
      describe OaiDcFileReader do
        let(:oai_dc_filename) { './spec/fixtures/sample_sdr.xml' }
        let(:resource_set) { mock_resource_set }
        before do
          allow(resource_set).to receive(:filename) { oai_dc_filename }
        end
        subject(:oai_dc_file_reader) { OaiDcFileReader.new(resource_set) }
        it { should be_a OaiDcFileReader }
        it { should be_a ResourceSet::SourceReader }
        describe '#resource_set' do
          subject { oai_dc_file_reader.resource_set }
          it { should eq resource_set }
        end
        describe '#read' do
          subject(:read) { oai_dc_file_reader.read }
          it { should be_an Array }
          it { should_not be_empty }
          its(:size) { should eq 1 }
          it 'should include only ResourceSet::Resources' do
            subject.each do |resource|
              expect(resource).to be_a ResourceSet::Resource
            end
          end
          describe 'the first record' do
            subject { read.first }
            context 'when the file is an SDR file' do
              its(:prefix) { should eq resource_set.prefix }
              its(:identifier) { should include 'DSS.NYCDCP_MONKEY_LION\DSS.Lion_Monkey' }
              its(:title) { should include 'LION' }
              its(:publisher) { should include 'New York City Dept. of City Planning' }
              its(:available) { should include 'http://magellan.home.nyu.edu/datasets/zips/NYCDCP_DCPLION_10CAV-Lion_GJK.zip' }
              its(:type) { should include 'Geospatial Data' }
              its(:description) { should include 'LION is a single line representation of New York City streets containing address ranges and other information.' }
              its(:edition) { should include '10C' }
              its(:series) { should include 'NYCDCP_DCPLION_10CAV' }
              its(:version) { should include 'DSS.NYCDCP_DCPLION_10cav\DSS.Lion_GJK' }
            end
          end
        end
      end
    end
  end
end
