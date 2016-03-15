METADATA_FIELDS = YAML.load_file(File.join(Rails.root, "config", "metadata_fields.yml"))["terms"]["vocabulary"].deep_symbolize_keys


