require "spec_helper"

describe ApplicationHelper do

  include BlacklightHelper
  include ApplicationHelper

  let(:field) { :desc_metadata__title_tesim }
  let(:solr_response) do
    Blacklight::SolrResponse.new(
    {
      :highlighting => {
        :highlight_field => { :title_ssm => ["The <span class=\"highlight\">Title</span>"] }
      }
    }, :solr_parameters => {:qf => "fieldOne^2.3 fieldTwo fieldThree^0.4", :pf => "", :spellcheck => 'false', :rows => "55", :sort => "request_params_sort" }
    )
  end
  let(:document) do
    {
      :document => SolrDocument.new({

      }, solr_response),
      :field => field
    }.with_indifferent_access
  end

  describe ".render_external_link" do
    subject { render_external_link(document) }
  end

end
