module ResourceSetMocks
  class MockSourceReader < Ichabod::ResourceSet::SourceReader
    def read
      5.times.map do |n|
        FactoryGirl.create :resource, identifier: "#{resource_set.prefix}-n"
      end
    end
  end

  class MockResourceSet < Ichabod::ResourceSet::Base
    self.prefix = 'mock'
    self.source_reader_class = MockSourceReader
  end
end
