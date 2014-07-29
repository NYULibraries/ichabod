require 'spec_helper'
class UrlPresenter < CatalogPresenter
  describe Url do
    let(:value) { 'value' }
    let(:text) { 'text' }
    subject(:url) { Url.new(value, text) }
    it { should be_a Url }
    describe '#value' do
      subject { url.value }
      it { should eq value }
    end
    describe '#text' do
      subject { url.text }
      it { should eq text }
      context 'when the text parameter is nil' do
        let(:text) { nil }
        it { should eq value }
      end
      context 'when initialized without a text parameter' do
        let(:url) { Url.new(value) }
        it { should eq value }
      end
    end
  end
end
