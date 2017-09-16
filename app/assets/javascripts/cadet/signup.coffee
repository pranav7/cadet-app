class Cadet.Signup
  constructor: (@company_el, @subdomain_el) ->

  init: ->
    @setupSubdomainAutoFill()
    @setupFormValidations()

  setupSubdomainAutoFill: ->
    @company_el.keyup (e) =>
      return @_handleBackSpaceEvent() if e.which == 8
      return unless @_isAlphabetOrSpace(e.which)
      @_populateSubdomain(e.key, e.which)

  setupFormValidations: ->
    $("#new_user").form({
      fields:
        email: ['empty', 'email']
        subdomain: ['empty']
    })

  _populateSubdomain: (key, keyCode) ->
    key = "-" if keyCode == 32
    @subdomain_el.val(@subdomain_el.val() + key.toLowerCase())

  _handleBackSpaceEvent: ->
    if @company_el.val() == ""
      @subdomain_el.val("")
    else
      current_val = @subdomain_el.val()
      @subdomain_el.val(current_val.substring(0, current_val.length - 1))

  _isAlphabetOrSpace: (charCode) ->
    (charCode >= 65 && charCode <= 90) || (charCode >= 97 && charCode <= 122) || (charCode == 32)

$(document).on "turbolinks:load", ->
  # Ties this JS to only Signup Page
  return unless $(".public.registrations").length > 0

  signup = new Cadet.Signup($("#user_memberships_attributes_0_company_attributes_name"), $("#user_memberships_attributes_0_company_attributes_subdomain"))
  signup.init()
