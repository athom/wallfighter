class EventHandler
  constructor: (world) ->
    listener = new window.keypress.Listener()
    listener.simple_combo "space", ->
      world.player1Press()
