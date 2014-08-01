class CatalogPresenter
  attr_reader :solr_document, :field_name

  def initialize(solr_document, field_name)
    unless solr_document.is_a?(SolrDocument)
      raise ArgumentError.new("Expecting #{solr_document} to be a SolrDocument")
    end
    @solr_document = solr_document
    @field_name = field_name
  end

  protected
  def blacklight_config
    @blacklight_config ||= CatalogController.blacklight_config
  end
end
