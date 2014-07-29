class UrlPresenter < CatalogPresenter
  class Url
    attr_reader :value, :text

    def initialize(value, text=nil)
      @value = value
      @text = (text || value)
    end
  end
end
