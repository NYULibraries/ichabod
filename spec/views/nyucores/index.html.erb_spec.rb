# require 'spec_helper'
describe 'nyucores/index', vcr: {cassette_name: 'views/nyucores/show'} do
  let(:items) { [create(:nyucore)] }
  it 'should render a list of nyucore items' do
    assign(:items, items)
    render
    assert_select "tr>th", text: "Title", count: 1
    assert_select "tr>td", text: "LION", count: 1
  end
end
