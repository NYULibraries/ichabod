module CollectionsHelper


  def single_fields
     @single_fields ||= Collection::SINGLE_FIELDS
  end

  def single_collection_fields
     @single_collection_fields ||= Collection::DESCRIPTIVE_FIELDS[:single]
  end

  def multiple_fields
     @multiple_fields ||= Collection::MULTIPLE_FIELDS
  end

  def admin_fields
     @admin_fields ||= Collection::ADMIN_FIELDS
  end

  def collection_fields
     @collection_fields ||= Collection::FIELDS
  end

  def required_fields
     @required_fields ||= Collection::REQUIRED_FIELDS
  end

  def get_boolean(value)
      (value.blank?||value=='1') ? true:false
  end

  def format_boolean_value(value,field)
     if(field.to_s == "discoverable")
       value == '1' ? 'Yes':'No'
     else
       value
     end
  end

end
