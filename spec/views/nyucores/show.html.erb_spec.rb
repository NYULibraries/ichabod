require 'spec_helper'
describe 'nyucores/show', vcr: {cassette_name: 'views/nyucores/show' } do
  let(:user) { build(:user) }
  let(:item) { create(:nyucore) }
  before do
    allow(controller).to receive(:current_user).and_return(user)
    assign(:item, item)
  end
  it 'should show the nyucore page' do
    render
    expect(rendered).to match /Title/
  end
end
