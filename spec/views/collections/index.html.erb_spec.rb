require 'spec_helper'
describe 'collections/index', vcr: {cassette_name: 'views/collections/index' } do
  let(:collections) { [create(:collection)] }
  before do
    allow(controller).to receive(:current_user).and_return(nil)
    assign(:collections, collections)
  end
  it 'should render a list of collections' do
    render
    assert_select "tr>th", text: 'Collection Name', count: 1
    assert_select "tr>td", text: 'Collection of records', count: 1
  end
end
