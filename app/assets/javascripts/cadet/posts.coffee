class Cadet.Posts
  constructor: ->
    # initialize some stuff here

  init: ->
    @linkifyText()
    @highlightSelectedComment()

  linkifyText: ->
    $(".content").linkify({
      className: (href, type) ->
        "link--#{type}"
      # tagName:
      #  mention: "span"
    })

  highlightSelectedComment: ->
    selected_el = $("##{location.hash.slice(1)}")
    selected_el.addClass("selected")

$(document).on "turbolinks:load", ->
  posts = new Cadet.Posts
  posts.init()
