require 'spec_helper'

describe "nyucores/edit", vcr: { cassette_name: "nyucore show edit form" } do
  let(:item) { create(:nyucore) }
  let(:user) { create(:user) }
  before(:each) { @item = item }
  before(:each) { controller.stub(:current_user).and_return(user) }

  it "should render the edit nyucore form" do
    render

    assert_select "form[action=?][method=?]", nyucore_path(item), "post" do
      assert_select "input#nyucore_title_native_metadata[name=?]", "nyucore[title][]"
    end
  end
end
