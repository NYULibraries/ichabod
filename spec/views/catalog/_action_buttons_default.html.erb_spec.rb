require 'spec_helper'

describe "catalog/_action_buttons_default" do

  let(:solr_document) { build(:solr_document, { :id => "fda:hdl-handle-net-2451-33612" }) }

  before do
    assign :response, double(:params => {})
    view.stub(:render_grouped_response?).and_return false
    view.stub(:current_search_session).and_return nil
    view.stub(:search_session).and_return({ 'counter' =>"2" })
  end
 
  it "should show 'Delete' and 'Edit' buttons to authorized user and pass parameter document_counter to Destroy method " do
    controller.stub(:current_user).and_return(build(:admin))
    render :partial => "catalog/action_buttons_default", :locals => { :document => solr_document, :document_counter => 1 }
    expect(rendered).to match /Edit/
    expect(rendered).to match /Delete/
    expect(rendered).to match /document_counter=2/
  end

  context "when document_counter parameter is not assign" do
    it "should read parameter counter from search_session to pass it as document_counter to destroy method " do
      controller.stub(:current_user).and_return(build(:admin))
      render :partial => "catalog/action_buttons_default", :locals => { :document => solr_document }
      expect(rendered).to match /document_counter=2/
    end
  end

  it "should not show 'Delete' and 'Edit' buttons to un-authorized user" do
    controller.stub(:current_user).and_return(build(:gis_cataloger))
    render :partial => "catalog/action_buttons_default", :locals => { :document => solr_document }
    expect(rendered).not_to eq /Edit/
    expect(rendered).not_to eq /Delete/
  end
end
