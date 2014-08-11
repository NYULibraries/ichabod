module ResourceSetMacros
  def mock_resource_set(options = {})
    ResourceSetMocks::MockResourceSet.new(options)
  end
end
