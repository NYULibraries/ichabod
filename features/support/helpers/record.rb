module IchabodFeatures
  module Record

    def format_factory(factory_title)
      factory_title.gsub(/ /,"_").downcase.to_sym
    end

    def accept_javascript_confirms
      page.evaluate_script('window.confirm = function() { return true; }')
    end

  end
end
