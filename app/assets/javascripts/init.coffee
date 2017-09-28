window.Cadet ||= {}
window.Cadet.Admin ||= {}

Cadet.init = ->
  # initialize common jQuery plugins and other Javascript libraries here
  $('.message .close').on 'click', ->
    $(this).parent().hide()

Cadet.Admin.init = ->
  # initialize common jQuery plugins and other Javascript libraries here

$(document).on "turbolinks:load", ->
  Cadet.init()
  Cadet.Admin.init()
