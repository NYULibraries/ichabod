require 'spec_helper'
module Ichabod
  module ResourceSet
    module SourceReaders
      describe LibGuidesXmlFileReader do
        let(:lib_guides_xml_filename) { './spec/fixtures/sample_libguides.xml' }
        let(:collection_code) { 'libguides' }
        let(:resource_set) { mock_resource_set }
        before do
          allow(resource_set).to receive(:collection_code) { collection_code }
          allow(resource_set).to receive(:filename) { lib_guides_xml_filename }
        end
        subject(:reader) { LibGuidesXmlFileReader.new(resource_set) }
        it { should be_a LibGuidesXmlFileReader }
        it { should be_a ResourceSet::SourceReader }
        describe '#resource_set' do
          subject { reader.resource_set }
          it { should eq resource_set }
        end
        describe '#read' do
          subject(:read) { reader.read }
          it { should be_an Array }
          it { should_not be_empty }
          its(:size) { should eq 3 }
          it 'should include only ResourceSet::Resources' do
            subject.each do |resource|
              expect(resource).to be_a ResourceSet::Resource
            end
          end
          describe 'a mapped Resource' do
            let(:index) { 0 }
            subject(:resource) { read[index] }
            its(:prefix) { should eq resource_set.prefix }
            its(:identifier) { should include 'http://guides.nyu.edu/content.php?pid=123457' }
            its(:title) { should include 'Africana Studies' }
            its(:creator) { should include 'Lib Rarian' }
            its(:available) { should include 'http://guides.nyu.edu/africana' }
            its(:type) { should include 'Research Guide' }
            its(:description) { should include 'African Studies' }
            its(:date) { should include '2013-09-19 08:16:07 AM' }
            describe '#subject' do
              subject { resource.subject }
              context 'when there are multiple categories' do
                it { should include 'Category 1' }
                it { should include 'Category 2' }
              end
              context 'when there is one category' do
                let(:index) { 1 }
                it { should include 'Area & Cultural Studies' }
              end
              context 'when there are no categories' do
                let(:index) { 2 }
                it { should be_blank }
              end
            end
          end
        end
      end
    end
  end
end
