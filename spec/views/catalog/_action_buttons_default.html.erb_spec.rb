require 'spec_helper'
require 'support/test_user_helper'

describe "catalog/_action_buttons_default" do

  let :document_one do
    SolrDocument.new id => 'xyz', :format => 'a'
  end

  let :document_two do
    SolrDocument.new id => 'xyz1', :format => 'a'
  end

  let :blacklight_config do
    Blacklight::Configuration.new do |config|
      config.index.thumbnail_field = :thumbnail_url
    end
  end

  before do
    assign :response, double(:params => {})
    allow(view).to receive(:render_grouped_response?).and_return false
    allow(view).to receive(:blacklight_config).and_return(blacklight_config)
    allow(view).to receive(:current_search_session).and_return nil
    allow(view).to receive(:search_session).and_return({})
  end

  it "should render the thumbnail if the document has one" do
    render :partial => "catalog/action_buttons_default", :locals => {:document => document_two, :document_counter => 1}
    expect(rendered).to match /document-thumbnail/
    expect(rendered).to match /src="http:\/\/localhost\/logo.png"/
  end

  it "should not render a thumbnail if the document does not have one" do
    render :partial => "catalog/thumbnail_default", :locals => {:document => document_one, :document_counter => 1}
    expect(rendered).to eq ""
  end

end
