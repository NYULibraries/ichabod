# require 'spec_helper'
describe 'nyucores/index', vcr: {cassette_name: 'views/nyucores/index' } do
  let(:items) { [build(:nyucore)] }
  before do
    allow(controller).to receive(:current_user).and_return(nil)
    assign(:items, items)
  end
  it 'should render a list of nyucore items' do
    render
    assert_select "tr>th", text: 'Title', count: 1
    assert_select "tr>td", text: 'LION', count: 1
  end
end
