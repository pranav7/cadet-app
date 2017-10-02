class Cadet.Admin.Dashboard
  constructor: (@listEl, @listItemEl) ->

  init: ->
    @bindItemClickListener()
    @_restoreScrollPosition()

  bindItemClickListener: ->
    that = @
    @listItemEl.click (e) ->
      e.stopPropagation()
      that._storeScrollPosition()
      true

  _storeScrollPosition: ->
    Cookies.set "scrollPos", @listEl.scrollTop()

  _restoreScrollPosition: ->
    scrollPos = Cookies.get("scrollPos")
    if scrollPos && scrollPos != "0"
      @listEl.scrollTop(scrollPos)
      Cookies.remove("scrollPos")

$(document).on "turbolinks:load", ->
  # Ties this JS to Posts show page
  return unless $(".admin.posts.show").length > 0

  dashboard = new Cadet.Admin.Dashboard($(".c-left-pane"), $(".admin-post-list-item"))
  dashboard.init()
