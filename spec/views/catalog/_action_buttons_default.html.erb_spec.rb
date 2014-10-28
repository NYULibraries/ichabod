require 'spec_helper'

describe "catalog/_action_buttons_default" do

  let(:solr_document) { build(:solr_document, { :id => "fda:hdl-handle-net-2451-33612" }) }
 
  it "should show 'Destroy' and 'Edit' buttons to authorized user" do
    controller.stub(:current_user).and_return(build(:admin))
    render :partial => "catalog/action_buttons_default", :locals => {:document => solr_document }
    expect(rendered).to match /Edit/
    expect(rendered).to match /Destroy/
  end

  it "should not show 'Destroy' and 'Edit' buttons to un-authorized user" do
    controller.stub(:current_user).and_return(build(:gis_cataloger))
    render :partial => "catalog/action_buttons_default", :locals => {:document => solr_document }
    expect(rendered).not_to eq /Edit/
    expect(rendered).not_to eq /Destroy/
  end

end
