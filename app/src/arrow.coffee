class Arrow
  COLOR_ARROW = 'RGBA(464, 224, 126, 0.7)'
  WIDTH = 200
  HEIGHT = 20

  SIDE_LEFT = 0
  SIDE_RIGHT = 1

  OFFSET = 500

  #V_SLOW = 4
  #V_MIDDLE = 5
  #V_FAST = 7
  V_SLOW = 5
  V_MIDDLE = 5
  V_FAST = 5

  CYCLE_COUNT = 800

  constructor: (side, world) ->
    @side = side
    @world = world
    @position = 0
    @position_x = 0
    @v = V_MIDDLE
    @cycle = 0
    @offset = 0
    @protecting_section_index = 0

  get_offset: () ->
    if @side == SIDE_LEFT
      return @offset-OFFSET
    if @side == SIDE_RIGHT
      return @offset+OFFSET

  set_position: (x, y) ->
    ratio = @world.half_height()/1000.0
    @origin_position = y
    @position = y*ratio
    ratio_x = OFFSET/2/1000.0
    @offset = x*ratio_x

  get_position: () ->
    return @origin_position

  get_direction: () ->
    v = Math.abs(@v)
    return @v/v

  get_half_heigh: () ->
    return HEIGHT/2

  shoot: (pos) ->
    index = @world.attackable_index(this)
    if index != 0 and index == @protecting_section_index
      return

  stop: () ->
    @halt = true

  start: () ->
    @halt = false

  render: (canvas) ->
    offset = @get_offset()
    canvas.fillRect(COLOR_ARROW, {
      x:offset-WIDTH/2,
      y:@position-HEIGHT/2,
      w:WIDTH,
      h:HEIGHT
    })
