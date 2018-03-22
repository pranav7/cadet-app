class Cadet.Posts
  constructor: ->
    # initialize some stuff here

  init: ->
    @highlightSelectedComment()
    @initializeCopyPostButton()

  highlightSelectedComment: ->
    commentId = location.hash.slice(1)
    $("##{commentId}").addClass("selected")

  initializeCopyPostButton: ->
    clipboard = new Clipboard("#copy-public-link")
    clipboard.on 'success', (e) ->
      copy_btn = $("#copy-public-link")
      copy_btn.html("Copied!")

      setTimeout (->
        copy_btn.html("Copy Public Link")
      ), 3000

$(document).on "turbolinks:load", ->
  posts = new Cadet.Posts
  posts.init()
