module MetadataFields
	extend ActiveSupport::Concern
	extend self
   
   NAMESPACE_ALL = 'all'
   MULTIPLE_ALL  = 'all'
   SECTION_NONE = 'none'
   DEFAULT_NAMESPACE = NAMESPACE_ALL
   DEFAULT_MULTIPLE  = MULTIPLE_ALL
   DEFAULT_SECTION = SECTION_NONE

   # get metadata fields
   def process_metadata_fields(ns:DEFAULT_NAMESPACE, multiple: DEFAULT_MULTIPLE, section: DEFAULT_SECTION)
   	  unless allowed_values(ns,multiple,section)
   	  	raise ArgumentError.new(
          "#{multiple} should be one of these values: #{allowed_values_for_multiple} 
          or #{ns} should be one of these values: #{allowed_values_for_ns}
          or #{section} should be one of these values: #{allowed_values_for_section}")	
   	  end

   	  # adding business logic here that handles "section" as well?
      # Might be clearner to have separate method?
      chk_key = ns.to_sym
      puts chk_key
      fields = []
      ordered_fields = []
   	  if METADATA_FIELDS.has_key?(chk_key)
   	  	add_fields_by_ns(multiple,fields,chk_key)
      elsif section != "none"
        add_all_by_section(multiple,ordered_fields,section)
   	  elsif ns == DEFAULT_NAMESPACE
   	  	add_all_fields(multiple,fields)
      end
      if ordered_fields.length > 0
        fields = ordered_fields.sort_by { |record| record[:order] }
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
     elsif ns == DEFAULT_NAMESPACE
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
     namespace = METADATA_FIELDS[ns][:info][:namespace]
     uri = METADATA_FIELDS[ns][:info][:uri]
     info = { namespace: namespace, uri: uri }
   end
   
   # output all fields regardless of namespace
   def add_all_fields(multiple,fields)
     METADATA_FIELDS.keys.each { |ns|
       add_fields_by_ns(multiple,fields,ns) 
     }
   end

   # output ordered fields by section regardless of namespace
   def add_all_by_section(multiple,ordered_fields,section)
     METADATA_FIELDS.keys.each { |ns|
       add_fields_by_section(multiple,ordered_fields,ns,section) 
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

   # add ordered fields by section specified by namespace
   def add_fields_by_section(multiple,ordered_fields,ns,section)
     #grabbing only fields
     metadata_fields = METADATA_FIELDS[ns][:fields]
     METADATA_FIELDS[ns][:fields].keys.each{ |field|
       # if output is true then print out field
       # if multiple has the default value
       # or one of the values in the yml file
       display_in_section = "display_in_" + section
       section_order = section + "_order"
       if metadata_fields[field][display_in_section.to_sym] == true
          ordered_fields.push({ :field => field, 
                                :order => metadata_fields[field][section_order.to_sym], 
                                :label => metadata_fields[field][:display_label] })
       end
     }
   end

   def allowed_values_for_multiple
   	 [true, false, DEFAULT_MULTIPLE]
   end

   def allowed_values_for_ns
    values = []
     METADATA_FIELDS.keys.each { |k| 
      values.push(k.to_s)
     }
     values << DEFAULT_NAMESPACE
   end

   def allowed_values_for_section
     ['search', 'full', 'facet', DEFAULT_SECTION]
   end


   def allowed_values(ns,multiple,section)
      allowed_values_for_ns.include?(ns) && allowed_values_for_multiple.include?(multiple) && allowed_values_for_section.include?(section)
   end

   private_class_method :add_all_fields, :add_fields_by_ns, :allowed_values_for_multiple,
                        :allowed_values_for_ns, :allowed_values_for_section, :allowed_values,
                        :get_all_sources_info, :get_metadata_source_info, :add_all_by_section,
                        :add_fields_by_section
end

