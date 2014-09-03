require 'spec_helper'
describe 'nyucores/new' do
  let(:user) { build(:user) }
  let(:item) { build(:nyucore) }
  before do
    allow(controller).to receive(:current_user).and_return(user)
    assign(:item, item)
  end
  it 'should render the new nyucore form' do
    render
    expect(rendered).to match /New Item/
  end
end
