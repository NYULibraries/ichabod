require 'spec_helper'
describe UrlPresenter do
  let(:url_values) { ['http://url.presenter.link'] }
  let(:type) { ['type'] }
  let(:solr_document) { create :solr_document, type: type, available: url_values }
  let(:field_name) { 'desc_metadata__available_tesim' }
  subject(:url_presenter) { UrlPresenter.new(solr_document, field_name) }
  it { should be_a CatalogPresenter }
  it { should be_a UrlPresenter }
  describe '#urls' do
    subject { url_presenter.urls }
    it { should be_an Array }
    it { should_not be_empty }
    it 'should be an Array of UrlPresenter::Urls' do
      subject.each do |url|
        expect(url).to be_a UrlPresenter::Url
      end
    end
    context 'when there are no URL values in the SolrDocument' do
      let(:url_values) { nil }
      it { should be_an Array }
      it { should be_empty }
    end
    context 'when the URL values in the SolrDocument are empty' do
      let(:url_values) { [] }
      it { should be_an Array }
      it { should be_empty }
    end
    context 'when there are no URL texts in the SolrDocument' do
      context 'type of the SolrDocument is not defined' do
        let(:type) { ['type', 'Geospatial Data'] }
        it 'should have Urls whose texts are "Download"' do
          subject.each do |url|
            expect(url.text).to eq 'Download'
          end
        end
      end
      context 'and one of the types of the SolrDocument "Geospatial Data"' do
        let(:type) { ['type', 'Geospatial Data'] }
        it 'should have Urls whose texts are "Download"' do
          subject.each do |url|
            expect(url.text).to eq 'Download'
          end
        end
      end
      context 'but none of the types of the SolrDocument is "Geospatial Data"' do
        it 'should have Urls whose texts are equal to their values' do
          subject.each do |url|
            expect(url.text).to eq url.value
          end
        end
      end
    end
    context 'when there are URL texts in the SolrDocument' do
      let(:solr_document) { create :solr_document, type: type, available: url_values, resource_text_display: url_texts }
      context 'and the URL values and texts are the same size' do
        let(:url_values) { ['http://url.value.1', 'http://url.value.2'] }
        let(:url_texts) { ['Text 1', 'Text 2'] }
        it 'should have Urls whose texts equal to the specified URL text in the SolrDocument' do
          subject.each_with_index do |url, index|
            expect(url.text).not_to eq url.value
            expect(url.text).not_to eq url_values[index]
            expect(url.text).to eq url_texts[index]
          end
        end
      end
      context 'but there are more URL values than texts' do
        let(:url_values) { ['http://url.value.1', 'http://url.value.2'] }
        let(:url_texts) { ['Text 1'] }
        it 'should have Urls whose texts equal to the specified URL text in the SolrDocument' do
          subject.each_with_index do |url, index|
            if url_texts[index].nil?
              expect(url.text).to eq url.value
              expect(url.text).to eq url_values[index]
            else
              expect(url.text).not_to eq url.value
              expect(url.text).not_to eq url_values[index]
              expect(url.text).to eq url_texts[index]
            end
          end
        end
      end
    end
  end
end
