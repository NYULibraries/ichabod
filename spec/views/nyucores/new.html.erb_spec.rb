# require 'spec_helper'
#
# describe "nyucores/new", vcr: { cassette_name: "nyucore show new form" } do
#   let(:item) { create(:nyucore) }
#   before(:each) { @item = item }
#
#   it "should render the new nyucore form" do
#     render
#
#     assert_select "form[action=?][method=?]", nyucores_path, "post" do
#       assert_select "input#nyucore_title[name=?]", "nyucore[title]"
#     end
#   end
# end
