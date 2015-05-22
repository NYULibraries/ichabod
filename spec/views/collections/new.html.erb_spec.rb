require 'spec_helper'
describe 'collections/new' do
  let(:user) { build(:user) }
  let(:collection) { build(:collection) }
  before do
    allow(controller).to receive(:current_user).and_return(user)
    assign(:collection, collection)
  end
  it 'should render the new collection form' do
    render
    expect(rendered).to match /New collection/
  end
end