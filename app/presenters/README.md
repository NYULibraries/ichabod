# Presenters in Ichabod

Ichabod leverages [Blacklight](https://github.com/projectblacklight/blacklight)
to display results directly from [Solr](http://lucene.apache.org/solr/) documents.
Much of the time this is exactly what we want. Sometimes it's not.

There are times when we want a more customized presentation layer on top of the "pure"
(meta)data represented by the Solr document. A good example of this is when presenting URLs.
URLs in the Solr document are just that, URLs. In Ichabod, we want those URLs to display
as links to the URL, possibly with some specific text based on another value in the Solr document.

Luckily, [Blacklight provides a way to do just that](https://github.com/projectblacklight/blacklight/wiki/Blacklight-configuration#using-a-helper-method-to-render-the-value).
Blacklight's method, pushes all the complexity to a Rails' helper module.
Often, this is a fine approach, but as our presentation logic gets more complex, we start running
into issues of testability and maintainability.  Helpers are Rails' magic (which is a red flag, IMO),
and can be hard to test. Instead of baking all that logic in to the Helper, we employ "Presenters" that
take a `SolrDocument` and a `:field_name`, and provide the necessary logic for displaying our fields.

Presenters are just Plain Old Ruby Objects(PORO). They are easy to test, have access to Ichabod's configuration, 
and [do one thing well](http://en.wikipedia.org/wiki/Single_responsibility_principle), i.e. presentation logic.

We still need the Rails' Helper methods, since that's how Blacklight likes to do things and Rails' Helpers are good at leveraging
awesome Rails' features like `:link_to`. But the a lot of the complexity inherent in presentation logic can be refactored out of
the Helpers and put in a more maintainable Presenter.

## Examples
Blacklight leverages helper methods so `controllers/catalog_controller.rb` should look something like:

```ruby
require 'blacklight/catalog'
class CatalogController < ApplicationController
  include Blacklight::Catalog
  ...
  configure_blacklight do |config|
    ...
    # Tell Blacklight to use :render_external_links to render this field
    config.add_index_field solr_name('desc_metadata__available', :stored_searchable, type: :string),
      label: 'Online Resource:', helper_method: :render_external_links
    end
  end
end
```

and `helpers/catalog_helper.rb` should look something like:

```ruby
module CatalogHelper
  ...
  # Called from Blacklight based on our configuration and passed a Hash of args
  # that include the document and field we're presenting
  def render_external_links(args)
    document = args[:document]
    field_name = args[:field]
    url_presenter = UrlPresenter.new(document, field_name)
    links = url_presenter.urls.collect do |url|
      link_to(url.text, url.value, {target: '_blank'})
    end
    links.join(field_value_separator).html_safe
  rescue
    nil
  end
end
```

And `presenters/url_presenter.rb` should look something like:

```ruby
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
        url_values.collect do |url_value|
          Url.new(url_value)
        end
      end
    end
  end

  private
  def url_values
    @url_values ||= solr_document[field_name]
  end
end
