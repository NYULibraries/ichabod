module CollectionsHelper
  def single_fields
     @single_fields ||= Collection::SINGLE_FIELDS
  end


  def multiple_fields
     @multiple_fields ||= Collection::MULTIPLE_FIELDS
  end

  def get_boolean(value)
     @checked = value.blank? ? true:false
  end

  def get_required(field)
     @required= field.to_s=="title" ? true:false
  end

end
