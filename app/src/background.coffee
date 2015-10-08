class BackGround
  WIDTH = 1600
  HEIGHT = 800

  WALL_WIDTH = 150


  COLOR_BORDER = 'RGB(100, 0, 240)'
  COLOR_LINE = 'RGB(100, 0, 240)'

  COLOR_ATTACK = 'RGBA(264, 224, 126, 0.4)'

  constructor: (size) ->
    @size = size
    @border = new Border
    @wall = new Wall(HEIGHT, WALL_WIDTH)

  render: (canvas) ->
    @border.render canvas
    @wall.render canvas
    return

    # inside lines
    widthUnit = WIDTH/@size
    heightUnit = HEIGHT/@size
    for i in [1...@size]
      i = i-(@size)/2
      x1 = i*widthUnit
      y1 = i*heightUnit
      canvas.drawLine(COLOR_BORDER, x1, -HEIGHT/2, x1, HEIGHT/2)
      canvas.drawLine(COLOR_BORDER, -HEIGHT/2, y1, HEIGHT/2, y1)
