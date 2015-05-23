module CollectionsHelper
  def single_fields
     @single_fields ||= Collection::SINGLE_FIELDS
  end

  def multiple_fields
     @multiple_fields ||= Collection::MULTIPLE_FIELDS
  end

  def workflow_fields
     @workflow_fields ||= Collection::WORKFLOW_FIELDS
  end

  def get_boolean(value)
      (value.blank?||value=='1') ? true:false
  end

  def format_boolean_value(value,field)
     if(field.to_s=="discoverable")
       value=='1' ? 'Yes':'No'
     else
       value
     end
  end

end
