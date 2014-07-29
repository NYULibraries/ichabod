module CatalogHelper
  include Blacklight::CatalogHelperBehavior

  # Taken from RockHall code:
  # https://github.com/awead/catalog/blob/1d4be363fc2a6f490b4f3343219181c581e130cc/app/helpers/marc_helper.rb
  def render_external_link(args)
    document = args[:document]
    field_name = args[:field]
    url_presenter = UrlPresenter.new(document, field_name)
    results = url_presenter.urls.collect do |url|
      link_to(url.text, url.value, {target: '_blank'})
    end
    results.join(field_value_separator).html_safe
  rescue
    nil
  end
end
