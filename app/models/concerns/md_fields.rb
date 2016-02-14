module MdFields
	extend ActiveSupport::Concern
	extend self

   def process_md_fields(ns:'all', multiple: 'all')
   	  chk_key = ns.to_sym
      fields = []
   	  if MD_FIELDS.has_key?(chk_key)
   	  	process_source_fields(chk_key,multiple,fields)
   	  elsif ns == 'all' 
   	  	parse_all_fields(multiple,fields)
   	  else
   	  	raise ArgumentError.new("#{ns} doesn't fall within required parameters of default value: all or existing sources in #{MD_FIELDS.keys}")
   	  end
   	  fields
   end
   
   def parse_all_fields(multiple,fields)
     MD_FIELDS.keys.each { |ns|
       process_source_fields(ns,multiple,fields) 
     }
   end

   def process_source_fields(ns,multiple,fields)
     MD_FIELDS[ns].keys.each{ |field|
       # if output is true then print out field
       output = multiple == 'all' ? true : MD_FIELDS[ns][field][:multiple] == multiple
	   fields.push(field) if output
     }
   end

   private_class_method :parse_all_fields, :process_source_fields
end

