# -*- encoding : utf-8 -*-
class SolrDocument

  include Blacklight::Solr::Document
  SolrDocument.use_extension( BlacklightOaiProvider::SolrDocumentExtension )

      # The following shows how to setup this blacklight document to display marc documents
  extension_parameters[:marc_source_field] = :marc_display
  extension_parameters[:marc_format_type] = :marcxml

  field_semantics.merge!(
                         :title => "title_display",
                         :author => "author_display",
                         :language => "language_facet",
                         :format => "format"
                         )



  # self.unique_key = 'id'

  # The following shows how to setup this blacklight document to display marc documents
  extension_parameters[:marc_source_field] = :marc_display
  extension_parameters[:marc_format_type] = :marcxml

  # Email uses the semantic field mappings below to generate the body of an email.
  SolrDocument.use_extension( Blacklight::Solr::Document::Email )

  # SMS uses the semantic field mappings below to generate the body of an SMS email.
  SolrDocument.use_extension( Blacklight::Solr::Document::Sms )

  # DublinCore uses the semantic field mappings below to assemble an OAI-compliant Dublin Core document
  # Semantic mappings of solr stored fields. Fields may be multi or
  # single valued. See Blacklight::Solr::Document::ExtendableClassMethods#field_semantics
  # and Blacklight::Solr::Document#to_semantic_values
  # Recommendation: Use field names from Dublin Core
  use_extension( Blacklight::Solr::Document::DublinCore)
  # Notes from 20150613
  # Field Semantics here only supports Unqualified Dublin Core.
  # In order to provide support for other formats (including Nyucore)
  # I think we need to define one or more Export Formats.
  # http://www.rubydoc.info/github/projectblacklight/blacklight/Blacklight/Document/Export
  # THen oai_provider _may_ be configurable to support them.
  # unapi definitely is: https://github.com/cbeer/blacklight_unapi
  field_semantics.merge!(
                         :identifier => "desc_metadata__identifier_tesim",
                         :title => "desc_metadata__title_tesim",
                         :publisher => "desc_metadata__publisher_tesim",
                         :type => "desc_metadata__type_tesim",
                         :description => "desc_metadata__description_tesim",
                         :available => "desc_metadata__available_tesim",
                         :edition => "desc_metadata__edition_tesim",
                         :series => "desc_metadata__series_tesim",
                         :version => "desc_metadata__version_tesim",
                         :restrictions => "desc_metadata__restrictions_tesim",
                         :addinfolink => "desc_metadata__addinfolink_tesim",
                         :addinfotext => "desc_metadata__addinfotext_tesim",
                         :isPartOf => "collection_ssm",
                         :date => "timestamp"
                         )
end
