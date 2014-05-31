# require 'spec_helper'
#
# describe "nyucores/index", vcr: { cassette_name: "nyucore show index template" } do
#   let(:items) { [create(:valid_nyucore)] }
#   before(:each) { @items = items }
#
#   it "should render a list of nyucore items" do
#     render
#
#     assert_select "tr>td", :text => "Title".to_s, :count => 1
#   end
# end
