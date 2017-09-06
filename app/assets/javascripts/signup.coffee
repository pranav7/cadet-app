$(document).ready ->
  company_el = $("#user_memberships_attributes_0_company_attributes_name")
  subdomain_el = $("#user_memberships_attributes_0_company_attributes_subdomain")
  company_el.blur ->
    return unless subdomain_el.val() == ""

    if company_el.val()?
      parameterized_name = company_el.val().toLowerCase().replace(/\s/g, "-")
      subdomain_el.val(parameterized_name)

  $("#new_user").form({
    fields:
      email: ['empty', 'email']
      subdomain: ['empty']
  })

  $('.message .close').on('click', ->
    $(this).parent().hide()
  )
