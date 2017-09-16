class Cadet.Signup
  constructor: (@company_el, @subdomain_el) ->

  init: ->
    @setupSubdomainAutoFill()
    @setupFormValidations()

  setupSubdomainAutoFill: ->
    @company_el.keyup (e) =>
      charCode = e.which
      return unless (charCode >= 65 && charCode <= 90) || (charCode >= 97 && charCode <= 122) || (charCode == 32)

      key = e.key
      key = "-" if charCode == 32

      @subdomain_el.val(@subdomain_el.val() + key.toLowerCase())
      return

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
