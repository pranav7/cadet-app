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
    commentId = location.hash.slice(1)
    $("##{commentId}").addClass("selected")

$(document).on "turbolinks:load", ->
  posts = new Cadet.Posts
  posts.init()
