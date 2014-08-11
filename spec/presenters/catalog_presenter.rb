require 'spec_helper'
describe CatalogPresenter do
  let(:solr_document) { create :solr_document }
  let(:field_name) { 'desc_field_name' }
  subject(:catalog_presenter) { CatalogPresenter.new(solr_document, field_name) }
  it { should be_a CatalogPresenter }
  describe '#solr_document' do
    subject { catalog_presenter.solr_document }
    it { should eq solr_document }
  end
  describe '#field_name' do
    subject { catalog_presenter.field_name }
    it { should eq field_name }
  end
  context 'when initialized with a solr_document argument that is not a SolrDocument' do
    let(:solr_document) { :invalid }
    it 'should raise an ArgumentError' do
      expect { subject }.to raise_error ArgumentError
    end
  end
end
