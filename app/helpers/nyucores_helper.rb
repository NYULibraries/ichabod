module NyucoresHelper

  # List of fields that have multiple values, so we can just loop in the view
  # TODO: Encapsulate this somewhere else
  def multivalue_fields
    @multivalue_fields ||= [:available, :description, :edition, :series, :version, :date, :format, :language, :relation, :rights, :subject, :citation]
  end

  # Retrieve the index of the current field so we can append that to the element's ID
  #
  # field       The array of field values from the nyucore object
  # index       The index of the item in its series, defaults to nil
  def format_field_index(field, index = nil)
    # When there are no values in the field array
    # the current id should be the default id, so don't pass any index back
    if field.present?
      # When index is nil, we're looking at the last element
      # which should have an index one greater than the last one
      # Example:
      #
      # field = ["Value1","Value2"]
      # return 2 # Then call the next element "id_prefix2"
      return field.length if index.nil?
      # When index is not 0 and is not nil (nil.to_i === 0)
      # Return that index, so that
      # Example:
      #
      # field = [0 => "Value1", 1 => "Value2"]
      # format_field_index(field, 0) === nil
      # format_field_index(field, 1) === 1
      return index if index.to_i > 0
    end
  end

end
