require 'spec_helper'
describe 'nyucores/show', vcr: {cassette_name: 'views/nyucores/show'} do
  let(:user) { create(:user) }
  let(:item) { create(:nyucore) }
  before { allow(controller).to receive(:current_user).and_return(user) }
  it 'should render the edit nyucore form' do
    assign(:item, item)
    render
  end
end
