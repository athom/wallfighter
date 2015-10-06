class Border
  WIDTH = 1600
  HEIGHT = 800
  COLOR_BORDER = 'RGB(100, 0, 240)'
  COLOR_LINE = 'RGB(100, 0, 240)'

  COLOR_ATTACK = 'RGBA(264, 224, 126, 0.4)'

  constructor: () ->

  render: (canvas) ->
    canvas.drawRect(COLOR_BORDER, {
      x:-WIDTH/2,
      y:-HEIGHT/2,
      w:WIDTH,
      h:HEIGHT
    })
