require 'spec_helper'
describe 'collections/index' do
  let(:collections) { [build(:collection)] }
  before do
    allow(controller).to receive(:current_user).and_return(nil)
    assign(:collections, collections)
  end
  it 'should render a list of collection collections' do
    render
    assert_select "tr>th", text: 'Title', count: 1
    assert_select "tr>td", text: 'Collection of records', count: 1
  end
end
