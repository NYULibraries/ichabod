require 'spec_helper'

describe "collections/new" do
  before(:each) do
    assign(:collection, stub_model(Collection,
      :identifier => "MyString",
      :title => "MyString",
      :creator => "MyString",
      :publisher => "MyString",
      :description => "MyString",
      :available => "MyString",
      :rights => "MyString"
    ).as_new_record)
  end

  it "renders new collection form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", collections_path, "post" do
      assert_select "input#collection_identifier[name=?]", "collection[identifier]"
      assert_select "input#collection_title[name=?]", "collection[title]"
      assert_select "input#collection_creator[name=?]", "collection[creator]"
      assert_select "input#collection_publisher[name=?]", "collection[publisher]"
      assert_select "input#collection_description[name=?]", "collection[description]"
      assert_select "input#collection_available[name=?]", "collection[available]"
      assert_select "input#collection_rights[name=?]", "collection[rights]"
    end
  end
end
