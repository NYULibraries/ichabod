FactoryGirl.define do
  factory :solr_document do
    skip_create
    initialize_with do
      new(
        {
          id: id,
          object_state_ssi: object_state,
          active_fedora_model_ssi: active_fedora_model,
          object_profile_ssm: object_profile,
          desc_metadata__identifier_tesim: identifier,
          desc_metadata__title_tesim: title,
          desc_metadata__publisher_tesim: publisher,
          desc_metadata__available_tesim: available,
          desc_metadata__type_tesim: type,
          desc_metadata__description_tesim: description,
          desc_metadata__edition_tesim: edition,
          desc_metadata__series_tesim: series,
          desc_metadata__version_tesim: version,
          has_model_ssim: ["info:fedora/afmodel:#{active_fedora_model}"],
          timestamp: timestamp,
          system_create_dtsi: created_at,
          system_modified_dtsi: updated_at,
          score: score
        }, solr_response
      )
    end
    solr_response { create(:solr_response) }
    id { 'solr:fedora-uniq-id' }
    active_fedora_model { 'Nyucore' }
    object_state { 'A' }
    object_profile { ['{"object_profile":{"some":{"long":"json","object":"as","a":"string"}}}'] }
    identifier { [id] }
    title { ['title'] }
    publisher { ['publisher'] }
    available { ['http://url.to.resource'] }
    type { ['type'] }
    description { ['This is a description of the resource.'] }
    edition { ['edition'] }
    series { ['series'] }
    version { ['version'] }
    timestamp { Time.now.iso8601 }
    created_at { timestamp }
    updated_at { timestamp }
    score { 4.944287 }
  end
end
