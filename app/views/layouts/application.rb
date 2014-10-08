# app/views/layouts/bobcat.rb
module Views
  module Layouts
    class Application < ActionView::Mustache
      def application_title
        "Ichabod"
      end

      # Print breadcrumb navigation
      def breadcrumbs
        breadcrumbs = super
        breadcrumbs << link_to('Catalog', catalog_index_url)
        breadcrumbs << link_to_unless_current(controller.controller_name.humanize) unless controller.controller_name.eql? "catalog"
        return breadcrumbs
      end

      # Prepend modal dialog elements to the body
      def prepend_body
        render partial: 'shared/ajax_modal'
      end

      # Prepend search box amd flash message partials before to yield
      def prepend_yield
        return unless show_search_box?

        prepend_yield = render :partial => 'shared/header_navbar' if show_search_box?

        prepend_yield += content_tag :div, :id => "main-flashes" do
          render :partial => '/flash_msg'
        end

        return prepend_yield
      end

      # Boolean for whether or not to show tabs
      def show_tabs
        false
      end

      # Only show search box on admin view or for search catalog, excluding bookmarks, search history, etc.
      def show_search_box?
        (controller.controller_name.eql? "catalog")
      end

    end
  end
end
