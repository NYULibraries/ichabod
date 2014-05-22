module NyucoresHelper

  def multivalue_fields
    @multivalue_fields ||= [:available, :description, :edition, :series, :version, :date, :format, :language, :relation, :rights, :subject, :citation]
  end

  def format_field_index(field, index = -1)
    return nil if index == 0 || field.length == 0
    return field.length if index == -1
    return index
  end

end
