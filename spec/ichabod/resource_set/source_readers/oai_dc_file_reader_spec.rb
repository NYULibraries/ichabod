require 'spec_helper'
module Ichabod
  module ResourceSet
    module SourceReaders
      describe OaiDcFileReader do
        let(:oai_dc_filename) { './spec/fixtures/sample_sdr.xml' }
        let(:resource_set) { mock_resource_set(filename: oai_dc_filename) }
        subject(:oai_dc_file_reader) { OaiDcFileReader.new(resource_set) }
        it { should be_a OaiDcFileReader }
        it { should be_a ResourceSet::SourceReader }
        describe '#resource_set' do
          subject { oai_dc_file_reader.resource_set }
          it { should eq resource_set }
        end
        describe '#read' do
          let(:resource) { subject.first }
          subject { oai_dc_file_reader.read }
          it { should be_an Array }
          it { should_not be_empty }
          it 'should contain 1 record' do
            expect(subject.size).to eq 1
          end
          it 'should include only ResourceSet::Resources' do
            subject.each do |resource|
              expect(resource).to be_a ResourceSet::Resource
            end
          end
          context 'when the file is an SDR file' do
            it 'should have a resource with a prefix "mock"' do
              expect(resource.prefix).to include 'mock'
            end
            it 'should have a resource with an identifier "DSS.NYCDCP_MONKEY_LION\DSS.Lion_Monkey"' do
              expect(resource.identifier).to include 'DSS.NYCDCP_MONKEY_LION\DSS.Lion_Monkey'
            end
            it 'should have a resource with a title "LION"' do
              expect(resource.title).to include 'LION'
            end
            it 'should have a resource with a publisher "New York City Dept. of City Planning"' do
              expect(resource.publisher).to include 'New York City Dept. of City Planning'
            end
            it 'should have a resource with an available "http://magellan.home.nyu.edu/datasets/zips/NYCDCP_DCPLION_10CAV-Lion_GJK.zip"' do
              expect(resource.available).to include 'http://magellan.home.nyu.edu/datasets/zips/NYCDCP_DCPLION_10CAV-Lion_GJK.zip'
            end
            it 'should have a resource with a type "Geospatial Data"' do
              expect(resource.type).to include 'Geospatial Data'
            end
            it 'should have a resource with a description "LION is a single line representation of New York City streets containing address ranges and other information."' do
              expect(resource.description).to include 'LION is a single line representation of New York City streets containing address ranges and other information.'
            end
            it 'should have a resource with an edition "10C"' do
              expect(resource.edition).to include '10C'
            end
            it 'should have a resource with an series "NYCDCP_DCPLION_10CAV"' do
              expect(resource.series).to include 'NYCDCP_DCPLION_10CAV'
            end
            it 'should have a resource with an version "DSS.NYCDCP_DCPLION_10cav\DSS.Lion_GJK"' do
              expect(resource.version).to include 'DSS.NYCDCP_DCPLION_10cav\DSS.Lion_GJK'
            end
          end
        end
      end
    end
  end
end
