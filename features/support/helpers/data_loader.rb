module IchabodFeatures
  module DataLoader

    def name_for_source(source)
      source.downcase.gsub(' ', '_').classify
    end

    def class_for_source(source)
      name_for_source(source).constantize
    end

    def instance_for_source(source)
      class_for_source(source).new
    end

    def prefix_for_source(source)
      instance_for_source(source).prefix
    end

    def fixture_file(source, ext = ".xml")
      "#{fixture_dir}/#{source}#{ext}"
    end

    def fixture_dir
      Rails.root.join("spec","fixtures")
    end
  end
end
