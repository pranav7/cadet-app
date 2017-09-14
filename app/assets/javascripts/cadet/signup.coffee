class Cadet.Signup
  constructor: (@company_el, @subdomain_el) ->

  init: ->
    @setupSubdomainAutoFill()
    @setupFormValidations()

  setupSubdomainAutoFill: ->
    @company_el.blur =>
      return unless @subdomain_el.val() == ""

      if @company_el.val()?
        parameterized_name = @company_el.val().toLowerCase().replace(/\s/g, "-")
        @subdomain_el.val(parameterized_name)

  setupFormValidations: ->
    $("#new_user").form({
      fields:
        email: ['empty', 'email']
        subdomain: ['empty']
    })

$(document).on "turbolinks:load", ->
  # Ties this JS to only Signup Page
  return unless $(".public.registrations").length > 0

  signup = new Cadet.Signup($("#user_memberships_attributes_0_company_attributes_name"), $("#user_memberships_attributes_0_company_attributes_subdomain"))
  signup.init()
