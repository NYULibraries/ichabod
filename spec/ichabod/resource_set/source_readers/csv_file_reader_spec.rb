require 'spec_helper'
module Ichabod
  module ResourceSet
    module SourceReaders
      describe CsvFileReader do
        let(:file_path) { 'ingest/2451-33611.csv' }
        let(:load_number_of_records) { 5 }
        let(:header_map) { { :identifier=>["dc.identifier.uri"], :title=> ["dc.title" ], :creator=>["dc.contributor.author" ],:publisher=>["dc.publisher" ],
    :type=>["dc.type.resource","dc.type" ],:description=>["dc.description.abstract","dc.description" ],:date=>["dc.date.issued" ],:format=>["dc.format" ],
      :rights=>["dc.rights" ],:subject=>["dc.subject","dc.coverage","dc.coverage.temporal" ] } }
        let(:resource_set) { mock_resource_set }
        before do
          allow(resource_set).to receive(:file_path) { file_path }
          allow(resource_set).to receive(:load_number_of_records) { load_number_of_records }
          allow(resource_set).to receive(:header_map) { header_map }
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
          its(:size) { should eq 5 }
          it 'should include only ResourceSet::Resources' do
            subject.each do |resource|
              expect(resource).to be_a ResourceSet::Resource
            end
          end
          describe 'the first record' do
            subject { read.first }
            context 'when first 5 records were loaded from csv file' do
              its(:prefix) { should eq resource_set.prefix }
              its(:identifier) { should eql ['http://hdl.handle.net/2451/33978'] }
              its(:title) { should eq ['Gallup GPSS and Assorted Poll Data and Questionnaires from 2001-2015'] }
              its(:subject) { should eql ['2001-2015'] }
              its(:format) { should eql ['.sav'] }
              its(:description) { should eql ['This archive contains data files in .sav format (SPSS) for Gallup Poll Social Series (GPSS) and other assorted polls that contain the question, "what is the most important issue facing our country today?" Note that these polls are not comprehensive; rather, they have been collected here simply because they contain the aforementioned question.'] }
            end
          end
        end
      end
    end
  end
end
