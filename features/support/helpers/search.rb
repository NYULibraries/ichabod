module IchabodFeatures
  module Search

    def ensure_root_path
      visit root_path unless current_path == root_path
    end


    def limit_by_facets(category, facets)
      within(:css, '#facets') do
        click_on(category)
        sleep(2)
        facets.split(", ").each do |facet|
          click_on(facet)
        end
      end
    end

    def search_phrase(phrase)
      within(:css, "form.search-query-form") do
        fill_in 'Search...', :with => phrase
      end
      click_button("Search")
    end

  end
end
