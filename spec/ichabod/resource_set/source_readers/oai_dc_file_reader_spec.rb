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
          subject { oai_dc_file_reader.read }
          it { should be_an Array }
          it { should_not be_empty }
          it 'should include only ResourceSet::Resources' do
            subject.each do |resource|
              expect(resource).to be_a ResourceSet::Resource
            end
          end
        end
      end
    end
  end
end
