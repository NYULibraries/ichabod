require 'spec_helper'
describe 'nyucores/edit', vcr: {cassette_name: 'views/nyucores/edit'} do
  let(:user) { create(:user) }
  let(:item) { create(:nyucore) }
  before do
    allow(controller).to receive(:current_user).and_return(user)
    assign(:item, item)
  end
  it 'should render the edit nyucore form' do
    render
    expect(rendered).to match /Edit Item/
  end
end
