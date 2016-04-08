module MetadataFields
	extend ActiveSupport::Concern
	extend self

	NAMESPACE_ALL = 'all'
	MULTIPLE_ALL  = 'all'
	DEFAULT_NAMESPACE = NAMESPACE_ALL
	DEFAULT_MULTIPLE  = MULTIPLE_ALL
	METADATA_FIELDS = YAML.load_file(File.join(Rails.root, "config", "metadata_fields.yml"))["terms"]["vocabulary"].deep_symbolize_keys
	# get metadata fields
	def process_metadata_fields(ns:DEFAULT_NAMESPACE, multiple: DEFAULT_MULTIPLE)
		unless allowed_values_for_ns.include?(ns)
			raise ArgumentError.new("#{ns} should be one of these values: #{allowed_values_for_ns}")
		end
		unless allowed_values_for_multiple.include?(multiple)
			raise ArgumentError.new("#{multiple} should be one of these values: #{allowed_values_for_multiple}")
		end
		chk_key = ns.to_sym
		fields = []
		if METADATA_FIELDS.has_key?(chk_key)
			add_fields_by_ns(multiple,fields,chk_key)
		elsif ns == NAMESPACE_ALL
			add_all_fields(multiple,fields)
		end
		fields
	end

	# get namespace and uri for
	# metadata namespace
	def get_source_info(ns:DEFAULT_NAMESPACE)
		unless allowed_values_for_ns.include?(ns)
			raise ArgumentError.new("#{ns} should be one of these values: #{allowed_values_for_ns}")
		end
		chk_key = ns.to_sym
		if METADATA_FIELDS.has_key?(chk_key)
			get_metadata_source_info(chk_key)
		elsif ns == NAMESPACE_ALL
			get_all_sources_info
		end

	end

	# get namespace and uri for all
	# metadata sources
	def get_all_sources_info
		source_info = {}
		METADATA_FIELDS.keys.each { |ns|
			source_info[ns] = get_metadata_source_info(ns)
		}
		source_info
	end

	# get source info by namespace
	def get_metadata_source_info(ns)
		METADATA_FIELDS[ns][:info]
	end

	# output all fields regardless of namespace
	def add_all_fields(multiple,fields)
		METADATA_FIELDS.keys.each { |ns|
			add_fields_by_ns(multiple,fields,ns)
		}
	end

	# add fields specified by namespace
	def add_fields_by_ns(multiple,fields,ns)
		#grabbing only fields
		metadata_fields = METADATA_FIELDS[ns][:fields]
		METADATA_FIELDS[ns][:fields].keys.each{ |field|
			# if output is true then print out field
			# if multiple has the default value
			# or one of the values in the yml file
			output = ( multiple == DEFAULT_MULTIPLE ) ?
			true :
			metadata_fields[field][:multiple] == multiple
			fields.push(field) if output
		}
	end

	def allowed_values_for_multiple
		[true, false, MULTIPLE_ALL]
	end

	def allowed_values_for_ns
		values = []
		METADATA_FIELDS.keys.each { |k|
			values << k.to_s
		}
		values << NAMESPACE_ALL
	end

	private_class_method :add_all_fields, :add_fields_by_ns, :allowed_values_for_multiple, :allowed_values_for_ns,
	:get_all_sources_info, :get_metadata_source_info
end
