# Add an additional link field to multivalued nyucore fields
#
# @element The "+" button element after multivalued fields
#
class AdditionalFieldLink
  constructor: (element) ->
    @el = $(element)

  # Get element ID with no index attached
  generic_element_id: ->
    @generic_element_input().attr("id")

  # Get the shared element name for multivalued fields
  generic_element_name: ->
    @generic_element_input().attr("name")

  # Get the first element of the series, which has no index
  generic_element: ->
    @el.closest("div").find("div:first-of-type")

  # Get the input element of the first element of the series
  generic_element_input: ->
    @generic_element().find("input")

  # Get the count of fields of this element
  get_element_count: ->
    $("input[name='"+@generic_element_name()+"']").size()

  # Clone the element and change the ID, and nil the value
  cloned_element: ->
    $cloned = @generic_element().clone()
    $cloned.find("input").attr("id", @generic_element_id() + @get_element_count()).val("")
    return $cloned

  # Append a cloned version of the first element in this list
  # to the end of the list
  append_new_field: ->
    @el.closest("div").find("div:last-of-type").after(@cloned_element())

$ ->
  # Add a "+" link after multivalued nyucore fields
  add_more_link = $("<a />").addClass("btn btn-primary").html("+").on 'click', ->
    more_link = new AdditionalFieldLink(this)
    more_link.append_new_field()

  $("[name^=nyucore][name$='[]']").parent("div").parent("div").append(add_more_link)
