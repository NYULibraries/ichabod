json.array!(@collections) do |collection|
  json.extract! collection, :id, :identifier, :title, :creator, :publisher, :description, :available, :rights
  json.url collection_url(collection, format: :json)
end
