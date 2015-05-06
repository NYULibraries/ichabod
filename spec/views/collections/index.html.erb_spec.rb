require 'spec_helper'

describe "collections/index" do
  before(:each) do
    assign(:collections, [
      stub_model(Collection,
        :identifier => "Identifier",
        :title => "Title",
        :creator => "Creator",
        :publisher => "Publisher",
        :description => "Description",
        :available => "Available",
        :rights => "Rights"
      ),
      stub_model(Collection,
        :identifier => "Identifier",
        :title => "Title",
        :creator => "Creator",
        :publisher => "Publisher",
        :description => "Description",
        :available => "Available",
        :rights => "Rights"
      )
    ])
  end

  it "renders a list of collections" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Identifier".to_s, :count => 2
    assert_select "tr>td", :text => "Title".to_s, :count => 2
    assert_select "tr>td", :text => "Creator".to_s, :count => 2
    assert_select "tr>td", :text => "Publisher".to_s, :count => 2
    assert_select "tr>td", :text => "Description".to_s, :count => 2
    assert_select "tr>td", :text => "Available".to_s, :count => 2
    assert_select "tr>td", :text => "Rights".to_s, :count => 2
  end
end
