require 'vcr'

VCR.configure do |c|
  # Capybara with poltergeist js driver uses this /__identify__ path
  # which we want to always ignore in VCR
  # Selenium uses the /hub/session path
  # See: https://github.com/vcr/vcr/issues/229
  c.ignore_request do |request|
    URI(request.uri).path == "/__identify__" || URI(request.uri).path =~ /\/hub\/session/
  end
  c.default_cassette_options = { allow_playback_repeats: true, match_requests_on: [:method, :uri, :body], record: :once }
  c.hook_into :webmock
  c.ignore_localhost = true
  c.allow_http_connections_when_no_cassette = true
  c.cassette_library_dir     = 'features/cassettes'
  c.filter_sensitive_data('https://rosie.the.riveter') { ENV['ICHABOD_ROSIE_ENDPOINT_URL'] }
  c.filter_sensitive_data('https://voices.of.food') { ENV['ICHABOD_VOICE_ENDPOINT_URL'] }
  c.filter_sensitive_data('https://nyupress.open.access') { ENV['ICHABOD_NYUPRESS_ENDPOINT_URL'] }
end

VCR.cucumber_tags do |t|
  t.tag '@vcr', use_scenario_name: true
end

Around('@vcr') do |scenario, block|
  VCR.configure { |configuration| configuration.ignore_localhost = false }
  block.call
  VCR.configure { |configuration| configuration.ignore_localhost = true }
end
