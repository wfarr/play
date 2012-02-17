# Sets up the app routing with URLs and state and shit.

play = exports ? this

class play.Router
  # Create a new Router instance by routing on this specific path.
  constructor: (path) ->
    @path = path

  # A Hash of all of the interactions in Play.
  routes:
    '/': 'index'

  # Route the app.
  go: () =>
    route = @routes[@path]

    if route
      @[route]()
    else
      @user()

  # The home page.
  index: () ->
    play.requestAndRenderNowPlaying()
    play.renderQueue()

  # The user page.
  user: () ->
    play.updateSongs(@path,"GET")