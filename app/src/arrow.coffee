class Arrow
  COLOR_ARROW = 'RGBA(464, 224, 126, 0.7)'
  WIDTH = 200
  HEIGHT = 20

  SIDE_LEFT = 0
  SIDE_RIGHT = 1

  OFFSET = 500

  V_SLOW = 4
  V_MIDDLE = 5
  V_FAST = 7
  #V_SLOW = 1
  #V_MIDDLE = 1
  #V_FAST = 1

  CYCLE_COUNT = 800

  constructor: (side, world) ->
    @side = side
    @world = world
    @position = 0
    @v = V_MIDDLE
    @cycle = 0
    @offset = 0
    @is_shooting = false
    @is_shooting_back = false
    @protecting_section_index = 0

  get_offset: () ->
    if @side == SIDE_LEFT
      return @offset-OFFSET
    if @side == SIDE_RIGHT
      return @offset+OFFSET

  set_position: (position) ->
    @position = position

  get_position: () ->
    return @position

  get_half_heigh: () ->
    return HEIGHT/2

  shoot: () ->
    index = @world.attackable_index(this)
    if index != 0 and index == @protecting_section_index
      return
    @is_shooting = true

  next_volocity: () ->
    v = Math.abs(@v)
    if v == 0
      return @last_volocity
    sign = @v/v
    if v == V_MIDDLE
      return sign*V_FAST
    if v == V_FAST
      return sign*V_SLOW
    if v == V_SLOW
      return sign*V_MIDDLE

  is_hit: () ->
    offset = 0
    index = @world.attackable_index(this)
    if index != 0
      offset = @world.break_offset(index)
    if @side == SIDE_RIGHT
      offset = -offset
    d = offset + @world.half_width() - 2*WIDTH - 150
    if @side == SIDE_LEFT
      return @offset >= d
    if @side == SIDE_RIGHT
      return @offset <= -d

  shoot_forward: () ->
    v = Math.abs(@v)
    if @side == SIDE_RIGHT
      v = -v
    @offset += v
    if @is_hit()
      @is_shooting_back = true
      index = @world.attackable_index(this)
      if index != 0
        offset = @world.move_break(index, @side)

  stop: () ->
    @halt = true

  shoot_back: () ->
    v = Math.abs(@v)
    if @side == SIDE_LEFT
      v = -v
    @offset += v
    if @offset <= 0 and @side == SIDE_LEFT or @offset >= 0 and @side == SIDE_RIGHT
      @is_shooting_back = false
      @is_shooting = false
      @protecting_section_index = @world.attackable_index(this)

  roaming: () ->
    return if @halt
    if @world.attackable_index(this) == 0
      @protecting_section_index = 0
    @position += @v
    h = @world.half_height()
    if @position >= h
      @v = -@v
    if @position <= -h
      @v = -@v

  volocity_change: () ->
    @cycle += 1
    if @cycle == CYCLE_COUNT
      @v = @next_volocity()
      @cycle = 0

  run: () ->
    if @is_shooting_back
      @shoot_back()
    else if @is_shooting
      @shoot_forward()
    else
      @roaming()
    @volocity_change()


  render: (canvas) ->
    @run()
    offset = @get_offset()
    canvas.fillRect(COLOR_ARROW, {
      x:offset-WIDTH/2,
      y:@position-HEIGHT/2,
      w:WIDTH,
      h:HEIGHT
    })
