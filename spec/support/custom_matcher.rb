RSpec::Matchers.define :match_ichabod_source_uri_hash do |expected|
   match do |actual|
      expect(actual.keys).to match_array(expected.keys)
      expected.keys.each { |k|
         expect(actual[k]).to eq(expected[k])
      }
   end
end
