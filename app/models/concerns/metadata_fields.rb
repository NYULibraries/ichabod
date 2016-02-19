module MetadataFields
	extend ActiveSupport::Concern
	extend self
   
   DEFAULT_VALUE = 'all' 

   def process_metadata_fields(ns:DEFAULT_VALUE, multiple: DEFAULT_VALUE)
   	  unless allowed_values(ns,multiple)
   	  	raise ArgumentError.new(
          "#{multiple} should be one of these values: #{allowed_values_for_multiple} 
          or #{ns} should be one of these values: #{allowed_values_for_ns}")	
   	  end

   	  chk_key = ns.to_sym
      fields = []
   	  if METADATA_FIELDS.has_key?(chk_key)
   	  	process_source_fields(chk_key,multiple,fields)
   	  elsif ns == DEFAULT_VALUE 
   	  	process_all_fields(multiple,fields)
      end
   	  fields
   end
   
   def process_all_fields(multiple,fields)
     METADATA_FIELDS.keys.each { |ns|
       process_source_fields(ns,multiple,fields) 
     }
   end

   def process_source_fields(ns,multiple,fields)
     METADATA_FIELDS[ns].keys.each{ |field|
       # if output is true then print out field
       output = multiple == DEFAULT_VALUE ? true : METADATA_FIELDS[ns][field][:multiple] == multiple
	     fields.push(field) if output
     }
   end

   def allowed_values_for_multiple
   	 [true, false, DEFAULT_VALUE]
   end

   def allowed_values_for_ns
    values = []
     METADATA_FIELDS.keys.each { |k| 
      values.push(k.to_s)
     }
     values << DEFAULT_VALUE
   end

   def allowed_values(ns,multiple)
      allowed_values_for_ns.include?(ns) && allowed_values_for_multiple.include?(multiple)
   end
   private_class_method :process_all_fields, :process_source_fields, :allowed_values_for_multiple, :allowed_values_for_ns, :allowed_values
end

