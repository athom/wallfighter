class Break
  COLOR_BREAK = 'RGB(100, 250, 240)'

  PUSH_FROM_LEFT = 0
  PUSH_FROM_RIGHT = 1

  DANGER_MIDDLE = 0
  DANGER_LEFT = -1
  DANGER_LEFT_2 = -2
  DANGER_LEFT_3 = -3
  DANGER_RIGHT = 1
  DANGER_RIGHT_2 = 2
  DANGER_RIGHT_3 = 3

  constructor: (height, world, width, position) ->
    @world = world
    @height = height
    @width = width
    @position = position
    @danger = DANGER_MIDDLE
    @is_falling = false
    #@danger = DANGER_LEFT
    #@danger = DANGER_LEFT_2
    #@danger = DANGER_RIGHT
    #@danger = DANGER_RIGHT_2

  get_offset: () ->
    delta = 2*@width / 3
    if @danger == DANGER_MIDDLE
      return 0
    if @danger == DANGER_LEFT
      return -1 * delta
    if @danger == DANGER_LEFT_2
      return -2 * delta
    if @danger == DANGER_LEFT_3
      return -3 * delta
    if @danger == DANGER_RIGHT
      return 1 * delta
    if @danger == DANGER_RIGHT_2
      return 2 * delta
    if @danger == DANGER_RIGHT_3
      return 3 * delta

  reset: () ->
    @danger = DANGER_MIDDLE

  move: (side) ->
    if side == PUSH_FROM_LEFT
      @danger += 1
    else if side == PUSH_FROM_RIGHT
      @danger -= 1
    #if @danger == DANGER_LEFT_3 or @danger == DANGER_RIGHT_3
      #@is_falling = true
    if @danger == DANGER_LEFT_3
      @is_falling = true
      @world.gameover(PUSH_FROM_RIGHT)
    else if @danger == DANGER_RIGHT_3
      @is_falling = true
      @world.gameover(PUSH_FROM_LEFT)


  render: (canvas) ->
    if @is_falling
      if @danger == DANGER_LEFT_3 or @danger == DANGER_RIGHT_3
        @position += 5
      if @position >= @world.half_height() - 50
        @is_falling = false


    offset = @get_offset()
    field =
      x: offset - @width
      y: @position-@height/2
      w: @width*2
      h: @height
    canvas.fillRect(COLOR_BREAK, field)
