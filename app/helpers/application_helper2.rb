module ApplicationHelper

  # Taken from RockHall code:
  # https://github.com/awead/catalog/blob/1d4be363fc2a6f490b4f3343219181c581e130cc/app/helpers/marc_helper.rb
  def render_external_link args, results = Array.new
    document = args[:document]
    field = args[:field]
    decorator = SolrDocumentUrlFieldsDecorator.new(document, blacklight_config, field)
    begin
      decorator.urls.each do |urls|
        results << link_to(urls.text, urls.to_s, { :target => "_blank" })
      end
    rescue
      return nil
    end
    return results.join(field_value_separator).html_safe
  end

  def field_value_separator
    tag(:br)
  end

end

       decorator = SolrDocumentUrlFieldsDecorator.new(document, blacklight_config, field)
    begin
      decorator.urls.each do |urls|
        results << link_to(urls.text, urls.to_s, { :target => "_blank" })
      end
    rescue
      return nil
    end
    return results.join(field_value_separator).html_safe
  end

  def field_value_separator
    tag(:br)
  end

end

