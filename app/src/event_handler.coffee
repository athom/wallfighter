class EventHandler
  constructor: (world) ->
    #onkeydown = (ev, wm) ->
      #console.log(ev)
      #switch ev.keyCode
        #when 32
          #world.player1Press()
    #document.addEventListener('keydown', onkeydown, false)
    listener = new window.keypress.Listener()
    listener.simple_combo "space", ->
      world.player1Press()
