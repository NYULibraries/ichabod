module NavigationHelpers
  def path_to(page_name)

    catalog_path='http://0.0.0.0:3000/catalog/'
    
    case page_name

    when /the home\s?page/
      root_path
    when /desc_metadata__type_sim/
      catalog_path+page_name
    else
      
      begin
        page_name =~ /the (.*) page/
        path_components = $1.split(/\s+/)
        self.send(path_components.push('path').join('_').to_sym)
        
      rescue Object => e
        raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
         "Now, go and add a mapping in #{__FILE__}"
      end
    end
  end

  #special navigation case when we limit search to a subset of data
  def use_facet(facet_name)

     visit path_to('?f[desc_metadata__type_sim][]='+facet_name)
  end

end

World(NavigationHelpers)