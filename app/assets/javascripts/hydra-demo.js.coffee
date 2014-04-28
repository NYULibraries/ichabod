$ ->
  add_more_link = $("<a />").addClass("btn btn-primary").html("+").on 'click', ->
    $(this).prev().closest("div").after($(this).prev().clone())
  
  $("[name^=nyucore][name$='[]']").parent("div").parent("div").append(add_more_link)