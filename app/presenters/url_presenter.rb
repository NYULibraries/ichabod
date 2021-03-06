class UrlPresenter < CatalogPresenter
  class Url
    attr_reader :value, :text

    def initialize(value, text=nil)
      @value = value
      @text = (text || value)
    end
  end

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
    @solr_document_types ||= (solr_document['desc_metadata__type_tesim'] || [])
  end

  def url_text_for_index(index)
     url_texts[index] unless  url_texts.blank? || url_texts[index].blank?
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
