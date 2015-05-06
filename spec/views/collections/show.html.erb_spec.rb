require 'spec_helper'

describe "collections/show" do
  before(:each) do
    @collection = assign(:collection, stub_model(Collection,
      :identifier => "Identifier",
      :title => "Title",
      :creator => "Creator",
      :publisher => "Publisher",
      :description => "Description",
      :available => "Available",
      :rights => "Rights"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Identifier/)
    rendered.should match(/Title/)
    rendered.should match(/Creator/)
    rendered.should match(/Publisher/)
    rendered.should match(/Description/)
    rendered.should match(/Available/)
    rendered.should match(/Rights/)
  end
end
