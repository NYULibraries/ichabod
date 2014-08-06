module IchabodFeatures
  module DataLoader

    def fixture_file(source, ext = ".xml")
      "#{fixture_dir}/#{source}#{ext}"
    end

    def fixture_dir
      Rails.root.join("spec","fixtures")
    end

  end
end
