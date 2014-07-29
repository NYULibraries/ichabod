class UrlPresenter < CatalogPresenter
  def urls
    @urls ||= begin
      if url_values.nil?
        []
      else
        url_values.collect.each_with_index do |url_value, index|
          Url.new(url_value, url_text_for_index(index))
        end
      end
    end
  end

  private
  def solr_document_types
    @solr_document_types ||= solr_document['desc_metadata__type_tesim']
  end

  def url_text_for_index(index)
    if url_texts.blank? || url_texts[index].blank?
      if solr_document_types.include? 'Geospatial Data'
        I18n.t('catalog.urls.download_text')
      end
    else
      url_texts[index]
    end
  end

  def url_values
    @url_values ||= solr_document[field_name]
  end

  def url_texts
    @url_texts ||= solr_document[text_field_name]
  end

  def text_field_name
    @text_field_name ||= blacklight_config.show_fields[field_name.to_s][:text]
  end
end
