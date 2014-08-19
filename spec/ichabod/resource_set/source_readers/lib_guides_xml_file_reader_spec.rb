require 'spec_helper'
module Ichabod
  module ResourceSet
    module SourceReaders
      describe LibGuidesXmlFileReader do
        let(:lib_guides_xml_filename) { './spec/fixtures/sample_libguides.xml' }
        let(:resource_set) { mock_resource_set }
        before do
          allow(resource_set).to receive(:filename) { lib_guides_xml_filename }
        end
        subject(:reader) { LibGuidesXmlFileReader.new(resource_set) }
        it { should be_a LibGuidesXmlFileReader }
        it { should be_a ResourceSet::SourceReader }
        describe '#resource_set' do
          subject { reader.resource_set }
          it { should eq resource_set }
        end
        describe '#read', half_baked: true do
          subject(:read) { reader.read }
          it { should be_an Array }
          it { should_not be_empty }
          its(:size) { should eq 1 }
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
