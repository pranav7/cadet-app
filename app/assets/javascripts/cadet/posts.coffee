class Cadet.Posts
  constructor: ->
    # initialize some stuff here

  init: ->
    @linkifyComments()

  linkifyComments: ->
    $(".comment").linkify ->
      target: "_blank"

$(document).on "turbolinks:load", ->
  posts = new Cadet.Posts
  posts.init()
