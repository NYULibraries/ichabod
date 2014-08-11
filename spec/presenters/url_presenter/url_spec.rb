require 'spec_helper'
describe UrlPresenter::Url do
  let(:value) { 'value' }
  let(:text) { 'text' }
  subject(:url) { UrlPresenter::Url.new(value, text) }
  it { should be_a UrlPresenter::Url }
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
      let(:url) { UrlPresenter::Url.new(value) }
      it { should eq value }
    end
  end
end
