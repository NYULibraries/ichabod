require "spec_helper"

describe ApplicationHelper do

  include BlacklightHelper
  include ApplicationHelper

  def solr_name(*args)
    Solrizer.default_field_mapper.solr_name(*args)
  end

  let(:title) { "The Title" }
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
        :desc_metadata__title_tesim => [title]
      }, solr_response),
      :field => field
    }.with_indifferent_access
  end
  let(:blacklight_config) do
    @config ||= Blacklight::Configuration.new.configure do |config|
      config.index.show_link = "desc_metadata__title_tesim"
      config.index.record_display_type = "desc_metadata__format_tesim"

      config.show.html_title = "desc_metadata__title_tesim"
      config.show.heading = "desc_metadata__title_tesim"
      config.show.display_type = "desc_metadata__format_tesim"

      config.add_show_field solr_name('desc_metadata__title', :stored_searchable, type: :string), :label => 'Title:'
      config.add_show_field solr_name('desc_metadata__creator', :stored_searchable, type: :string), :label => 'Creator:'
      config.add_show_field solr_name('desc_metadata__available', :stored_searchable, type: :string), :label         => 'Online Resource:',
                                                                                                      :helper_method => :render_external_link,
                                                                                                      :text          => 'resource_text_display'
    end
  end

  describe ".render_external_link" do
    subject { render_external_link(document) }
    it { should_not be_nil }
  end

end
