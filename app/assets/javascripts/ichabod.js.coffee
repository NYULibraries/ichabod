# Add an additional link field to multivalued nyucore fields
#
# @element The "+" button element after multivalued fields
#
class AdditionalFieldLink
  constructor: (element) ->
    @element = $(element)

  id: ->
    @input_id() + @count()

  # Get input ID with no index attached
  input_id: ->
    @input().find("input").attr("id")

  # Get the shared element name for multivalued fields
  name: ->
    @input().find("input").attr("name")

  # Get the first element of the series, which has no index
  input: ->
    @element.closest("div").find("div.form-group").first()

  # Get the count of fields of this element
  count: ->
    $("input[name='#{@name()}']").size()

  # Clone the element and change the ID, and nil the value
  clone: ->
    clone = @input().clone()
    clone.find("input").attr("id", @id()).val("")
    return clone

  # Append a cloned version of the first element in this list
  # to the end of the list
  append_new_field: ->
    @element.closest("div").find("div.form-group").last().after(@clone())

$ ->
  # Add a "+" link after multivalued nyucore fields
  add_more_link = $("<a />").addClass("btn btn-primary").html("+").on 'click', ->
    more_link = new AdditionalFieldLink(this)
    more_link.append_new_field()

  $("[name^=nyucore][name$='[]']").parent("div").parent("div").append(add_more_link)
