class Cadet.Posts
  constructor: ->
    # initialize some stuff here

  init: ->
    @linkifyText()

  linkifyText: ->
    $(".content").linkify({
      className: (href, type) ->
        "link--#{type}"
      # tagName:
      #  mention: "span"
    })

$(document).on "turbolinks:load", ->
  posts = new Cadet.Posts
  posts.init()
