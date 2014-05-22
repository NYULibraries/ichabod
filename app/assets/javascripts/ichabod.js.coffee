$ ->
  add_more_link = $("<a />").addClass("btn btn-primary").html("+").on 'click', ->
    first_el = $(this).closest("div").find("div:first-of-type")
    first_id = first_el.find("input").attr("id")
    shared_name = first_el.find("input").attr("name")
    index = $("input[name='"+shared_name+"']").size()
    new_el = first_el.clone()
    new_el.find("input").attr("id", first_id + index).val("")
    $(this).prev().closest("div").after(new_el)

  $("[name^=nyucore][name$='[]']").parent("div").parent("div").append(add_more_link)
