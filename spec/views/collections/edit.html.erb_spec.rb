require 'spec_helper'
describe 'collection/edit' do
  let(:user) { build(:user) }
  let(:collection) { create(:collection) }
  before do
    allow(controller).to receive(:current_user).and_return(user)
    assign(:collection, collection)
  end
  it 'should render the edit collection form' do
    render
    expect(rendered).to match /Edit Item/
  end
end