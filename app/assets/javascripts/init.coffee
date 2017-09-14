window.Cadet ||= {}

Cadet.init = ->
  # initialize common jQuery plugins and other Javascript libraries here
  $('.message .close').on 'click', ->
    $(this).parent().hide()

$(document).on "turbolinks:load", ->
  Cadet.init()
