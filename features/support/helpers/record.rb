module IchabodFeatures
  module Record

    def accept_javascript_confirms
      page.evaluate_script('window.confirm = function() { return true; }')
    end

  end
end
