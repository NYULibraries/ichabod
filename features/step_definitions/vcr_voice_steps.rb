Around('@vcr_voice_collection') do |scenario, block|
  using_vcr_cassette('Collection_facet/Filter by Voices of the Food Revolution') do
    block.call
  end
end

Around('@vcr_voice_search') do |scenario, block|
  using_vcr_cassette('Perform_a_basic_search/Search for Voices of the Food Revolution interview subject s name') do
    block.call
  end
end

def using_vcr_cassette(name)
  vcr_localhost_request do
    VCR.use_cassette(name, match_requests_on: [:method, :uri, :body], record: :once) do
      yield
    end
  end
end

def vcr_localhost_request
  VCR.configure { |configuration| configuration.ignore_localhost = false }
  yield
  VCR.configure { |configuration| configuration.ignore_localhost = true }
end
