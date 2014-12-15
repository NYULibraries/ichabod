require 'spec_helper'

describe "catalog/_document" do

  let(:solr_document) { build(:solr_document, { :id => "fda:hdl-handle-net-2451-33612" }) }
  let(:blacklight_config) { Blacklight::Configuration.new }
 
  before do
    assign :response, double(:params => {})
    view.stub(:render_grouped_response?).and_return false
    view.stub(:blacklight_config).and_return(blacklight_config)
    blacklight_config.index.partials = ['index_header','index','action_buttons']
    view.stub(:current_search_session).and_return nil
    view.stub(:search_session).and_return({})

    #authentication is perfrmed for nyucore not for solr_document so here we don't need authentication provider
    view.stub(:has_user_authentication_provider?) { false }
  end
  
  it "should render the action_buttons template" do
    stub_template "catalog/_index_header_default.html.erb" => "document_header"
    stub_template "catalog/_index_default.html.erb" => "index_default"
    stub_template "catalog/_action_buttons_default.html.erb" => "action_buttons"
    render :partial => "catalog/document", :locals => {:document => solr_document, :document_counter => 1 }
    expect(rendered).to match /action_buttons/
  end
end
