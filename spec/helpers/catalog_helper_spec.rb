require "spec_helper"

describe CatalogHelper do
  include BlacklightHelper
  let(:field) { 'desc_metadata__available_tesim' }
  let(:type) { 'type' }
  let(:available) { ["http://google.com"] }
  let(:resource_text_display) { ["Google"] }
  let(:document) { create :solr_document, type: type, available: available, resource_text_display: resource_text_display }
  describe ".render_external_links" do
    subject { render_external_links(document: document, field: field) }
    context 'when the link field has only one value' do
      it { should eql('<a href="http://google.com" target="_blank">Google</a>') }
    end
    context 'when the link field has more than one value' do
      let(:available) { ["http://yahoo.com","http://google.com"] }
      let(:resource_text_display) { ["Yahoo!", "Google"] }
      it { should eql('<a href="http://yahoo.com" target="_blank">Yahoo!</a><br /><a href="http://google.com" target="_blank">Google</a>') }
    end
    context 'when args are nil' do
      let(:document) { nil }
      it 'should not raise an error' do
        expect { subject }.to_not raise_error
      end
      it { should be_nil }
    end
  end

  describe ".render_collection_links" do
    let(:collection) { create(:collection)}
    let(:pid) { collection.pid }
    subject { render_collection_links(pid ) }
    context 'when the collection exist' do
      it { should eql('Collection of records') }
    end
    context 'when collection does not exists ' do
      let(:pid) { 'ichabodcollection:invalidpid' }
      it { should eql('Unknown Collection') }
    end
  end
end
