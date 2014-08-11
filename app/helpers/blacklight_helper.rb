# Override methods in Blacklight::BlacklightHelperBehavior
module BlacklightHelper
  include Blacklight::BlacklightHelperBehavior
  
  # Overrides Blacklight::BlacklightHelperBehavior#field_value_separator
  # which defaults the separator to ", " to display multivalue fields as
  # comma separated strings. Instead, we display each field on a new line.
  def field_value_separator
    tag(:br)
  end
end
