require 'spec_helper'
module Ichabod
  module ResourceSet
    module SourceReaders
      describe CsvFileReader do
        let(:file_path) { 'ingest/test_options.csv' }
        let(:header_map) { 
           {
             identifier: ["identifier.uri"], title: ["title" ], creator: ["contributor.author" ], publisher: [["publisher.place","publisher", "date.issued"], [":",","]],
             type: ["type.resource","type" ], description: ["description.abstract","description" ], date: ["date.issued"],
             format: ["format" ], rights: ["rights" ], subject: ["subject","coverage","coverage.temporal"], language: ["language"], spatial_subject: ["coverage.temporal"]
           }
         }
        let(:csv_reader_options) { { :col_sep=>";" } }
        let(:resource_set) { mock_resource_set }
        before do
          allow(resource_set).to receive(:file_path) { file_path }
          allow(resource_set).to receive(:header_map) { header_map }
          allow(resource_set).to receive(:csv_reader_options) { csv_reader_options }
        end
        subject(:csv_file_reader) { CsvFileReader.new(resource_set) }
        it { should be_a CsvFileReader }
        it { should be_a ResourceSet::SourceReader }
        describe '#resource_set' do
          subject { csv_file_reader.resource_set }
          it { should eq resource_set }
        end
        describe '#read', vcr: {cassette_name: 'resource sets/csv_file_reader'}  do
          subject(:read) { csv_file_reader.read }
          it { should be_an Array }
          it { should_not be_empty }
          its(:size) { should eq 3 }
          it 'should include only ResourceSet::Resources' do
            subject.each do |resource|
              expect(resource).to be_a ResourceSet::Resource
            end
          end

          describe 'the first record' do
            subject { read.first }
            context 'when test records were loaded from csv file' do
              its(:prefix) { should eq resource_set.prefix }
              its(:identifier) { should eql ['http://hdl.handle.net/2451/test2'] }
              its(:date) { should eql ["2015-03-14"] }
              its(:title) { should eq ["Test Data 2"] }
              its(:publisher) { should eq ["publisher_place:test publisher,2015-03-14"] }
              its(:creator) { should eq ["author2", "author3", "author4"] }
              its(:subject) { should eql ["Business--Demande", "Business--Supply", "Test Location"] }
              its(:description) { should eql ["Millions of US businesses dating back to 2010 the codebook."] }
              its(:language) { should eq 'English' }
              its(:spatial_subject) { should eql ["Test Location"] }
            end
          end
          describe 'when first joined column is blank it should use correct join signs' do
            subject { read.last }
            its(:publisher) { should eq  ["2015-04-14"] }
          end
          describe 'when not first joined columns are blank it should use correct join signs' do
            subject { read[1]}
            its(:publisher) { should eq ["Business,2015-02-14"] }
          end
        end
        context 'when number of columns to join mismatch with join sign in the  header map it should throw an error' do
          let(:header_map) { {identifier: [["identifier.uri"],[",",".",":"]]} }
          it 'should raise an ArgumentError' do
            expect { subject.read }.to raise_error ArgumentError
          end
        end
        context 'when attempt is made to join fields with multiple values it should throw an error' do
          let(:header_map) { {identifier: [["identifier.uri","subject"],[","]]} }
          it 'should raise an ArgumentError' do
            expect { subject.read }.to raise_error ArgumentError
          end
        end
      end
    end
  end
end
