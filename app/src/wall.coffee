class Wall
  COLOR_WALL = 'RGB(100, 0, 240)'

  constructor: (height, width) ->
    @height = height
    @width = width

  render: (canvas) ->
    canvas.drawLine(COLOR_WALL, -@width, -@height/2, -@width, @height/2)
    canvas.drawLine(COLOR_WALL, @width, -@height/2, @width, @height/2)
