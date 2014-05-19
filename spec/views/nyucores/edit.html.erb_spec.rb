require 'spec_helper'

describe "nyucores/edit", vcr: { cassette_name: "nyucore show edit form" } do
  let(:item) { create(:valid_nyucore) }
  before(:each) { @item = item }

  it "should render the edit nyucore form" do
    render

    assert_select "form[action=?][method=?]", nyucore_path(item), "post" do
      assert_select "input#nyucore_title[name=?]", "nyucore[title]"
    end
  end
end
