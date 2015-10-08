class EventHandler
  constructor: (world) ->
    listener = new window.keypress.Listener()
    #listener.simple_combo "a", ->
      #world.player1Press()
    #listener.simple_combo "k", ->
      #world.player2Press()
    listener.simple_combo "space", ->
      world.player1Press()
