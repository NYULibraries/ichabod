module ApplicationHelper

  # Taken from RockHall code:
  # https://github.com/awead/catalog/blob/1d4be363fc2a6f490b4f3343219181c581e130cc/app/helpers/marc_helper.rb
  def render_external_link args, results = Array.new
    begin
      value = args[:document][args[:field]]
      if value.length > 1
        value.each_index do |index|
          text      = args[:document][blacklight_config.show_fields[args[:field].to_s][:text]][index]
          url       = value[index]
          link_text = text.nil? ? url : text
          results << link_to(link_text, url, { :target => "_blank" })
        end
      else
        text      = args[:document].get(blacklight_config.show_fields[args[:field].to_s][:text])
        url       = args[:document].get(args[:field])
        metadata_type = args[:document]["desc_metadata__type_tesim"] 
        text = "Download" if metadata_type[0] == "Geospatial Data"
        link_text = text.nil? ? url : text
        results << link_to(link_text, url, { :target => "_blank" })
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
