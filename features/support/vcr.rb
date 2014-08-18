require 'vcr'

VCR.configure do |c|
  # Capybara with poltergeist js driver uses this /__identify__ path
  # which we want to always ignore in VCR
  # Selenium uses the /hub/session path
  # See: https://github.com/vcr/vcr/issues/229
  c.ignore_request do |request|
    URI(request.uri).path == "/__identify__" || URI(request.uri).path =~ /\/hub\/session/
  end
  c.default_cassette_options = { allow_playback_repeats: true, record: :new_episodes }
  c.hook_into :webmock
  c.cassette_library_dir     = 'features/cassettes'
  c.filter_sensitive_data('https://rosie.the.riveter') { ENV['ICHABOD_ROSIE_ENDPOINT_URL'] }
end

VCR.cucumber_tags do |t|
  t.tag '@vcr', use_scenario_name: true
end
