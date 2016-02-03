class Border
  WIDTH = 1600
  HEIGHT = 800
  COLOR_BORDER = 'RGB(100, 0, 240)'
  COLOR_LINE = 'RGB(100, 0, 240)'

  COLOR_ME = 'RGB(82, 183, 83)'
  COLOR_OPPOENT = 'RGB(233, 20, 40)'

  COLOR_ATTACK = 'RGBA(264, 224, 126, 0.4)'

  constructor: () ->

  render: (canvas) ->
    #canvas.drawText('black', '20px play', 'You', 0, -WIDTH/2)
    canvas.drawText(COLOR_ME, '50px play', '我方', -700, -300)
    canvas.drawText(COLOR_OPPOENT, '50px play', '敌方', 700, -300)
    #canvas.drawText(COLOR_BORDER, '20px play', 'You', 0, 0)
    canvas.drawRect(COLOR_BORDER, {
      x:-WIDTH/2,
      y:-HEIGHT/2,
      w:WIDTH,
      h:HEIGHT
    })
