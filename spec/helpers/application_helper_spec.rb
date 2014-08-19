require "spec_helper"

describe ApplicationHelper do

  include BlacklightHelper
  include ApplicationHelper

  def solr_name(*args)
    Solrizer.default_field_mapper.solr_name(*args)
  end

  let(:title) { "The Title" }
  let(:field) { :desc_metadata__title_tesim }
  let(:available) { ["http://google.com"] }
  let(:resource_text_display) { ["Google"] }
  let(:results) { [link_to("Old link","http://askjeeves.com")] }
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
        :desc_metadata__title_tesim => [title],
        :desc_metadata__available_tesim => available,
        :resource_text_display => resource_text_display
      }, solr_response),
      :field => field
    }.with_indifferent_access
  end
  # Mock the blacklight config, only the parts being used by this helper
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

    let(:field) { solr_name("desc_metadata__available") }

    subject { render_external_link(document) }

    context 'when the link field has only one value' do
      it { should eql('<a href="http://google.com" target="_blank">Google</a>') }
    end

    context 'when the link field has more than one value' do
      let(:available) { ["http://yahoo.com","http://google.com"] }
      let(:resource_text_display) { ["Yahoo!", "Google"] }
      it { should eql('<a href="http://yahoo.com" target="_blank">Yahoo!</a><br /><a href="http://google.com" target="_blank">Google</a>') }
    end

    context 'when initial links are passed in' do
      subject { render_external_link(document, results) }
      it 'should append to them' do
        expect(subject).to eql('<a href="http://askjeeves.com">Old link</a><br /><a href="http://google.com" target="_blank">Google</a>')
      end
    end

    context 'when args are nil' do
      let(:document) { nil }

      it 'should not raise an error' do
        expect { subject }.to_not raise_error
      end

      it { should be_nil }
    end
  end

  describe ".field_value_separator" do
    subject { field_value_separator }
    it { should eql("<br />") }
  end

end
