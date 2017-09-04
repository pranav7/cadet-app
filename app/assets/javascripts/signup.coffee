$(document).ready ->
  $("#user_company_attributes_name").blur ->
    return unless $("#user_company_attributes_subdomain").val() == ""
    company_name = $("#user_company_attributes_name").val()

    if company_name?
      parameterized_name = company_name.toLowerCase().replace(/\s/g, "")
      $("#user_company_attributes_subdomain").val(parameterized_name)

  $("new_user").form({
    fields:
      email: ['empty', 'email']
      subdomain: ['empty']
  })

  $('.message .close').on('click', ->
    $(this).parent().hide()
  )
