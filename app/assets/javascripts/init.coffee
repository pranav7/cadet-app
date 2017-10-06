window.Cadet ||= {}
window.Cadet.Admin ||= {}

Cadet.init = ->
  # initialize common jQuery plugins and other Javascript libraries here
  $('.ui.message .close').on 'click', ->
    $(this).parent().hide()

  setTimeout (->
    $(".ui.message").fadeOut(300)
  ), 3400

Cadet.Admin.init = ->
  # initialize common jQuery plugins and other Javascript libraries here

$(document).on "turbolinks:load", ->
  Cadet.init()
  Cadet.Admin.init()
