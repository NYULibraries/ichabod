require 'spec_helper'
describe 'collections/show', vcr: {cassette_name: 'views/collections/show' } do
  let(:user) { build(:user) }
  let(:collection) { create(:collection) }
  before do
    allow(controller).to receive(:current_user).and_return(user)
    assign(:collection, collection)
  end
  it 'should show the collection page' do
    render
    expect(rendered).to match /Title/
  end
end
