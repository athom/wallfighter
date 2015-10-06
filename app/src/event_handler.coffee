class EventHandler
  constructor: (world) ->
    $("#chess-board").click (e) ->
      clicked_point = {x: e.offsetX, y:e.offsetY}
      pos = world.board.point2pos(clicked_point)
      world.select pos

    $("#chess-board").mousemove (e) ->
      clicked_point = {x: e.offsetX, y:e.offsetY}
      pos = world.board.point2pos(clicked_point)
      world.hover pos


    listener = new window.keypress.Listener()
    listener.simple_combo "a", ->
      world.player1Press()
    listener.simple_combo "k", ->
      world.player2Press()
