require 'spec_helper'

describe "catalog/show.html.erb" do
  let(:solr_document) { build(:solr_document, { :id => "fda:hdl-handle-net-2451-33612" }) }
  let(:blacklight_config) { Blacklight::Configuration.new }

  before :each do
    view.stub(:has_user_authentication_provider?) { false }
    blacklight_config.show.partials = ['show_header','show','action_buttons']
    assign :document, solr_document
    allow(view).to receive(:blacklight_config).and_return(blacklight_config)
  end


  it "should render the action_buttons template" do
    allow(view).to receive(:render_grouped_response?).and_return(false)
    stub_template "catalog/_show_header_default.html.erb" => "show_header"
    stub_template "catalog/_show_default.html.erb" => "show_default"
    stub_template "catalog/_action_buttons_default.html.erb" => "action_buttons"
    render
    expect(rendered).to match /action_buttons/
  end
end
