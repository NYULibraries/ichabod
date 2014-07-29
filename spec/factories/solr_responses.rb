FactoryGirl.define do
  factory :solr_response, class: Blacklight::SolrResponse do
    data { Hash.new }
    request_params { Hash.new }
    skip_create
    initialize_with { new(data, request_params) }
  end
end
