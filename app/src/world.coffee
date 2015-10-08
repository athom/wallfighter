class World
  BREAK_WIDTH = 150
  BREAK_HEIGH = 100

  ARROW_SIDE_LEFT = 0
  ARROW_SIDE_RIGHT = 1

  constructor: (canvas, bar, connector) ->
    @canvas = canvas
    @bar = bar
    @connector = connector
    @connector.set_world(this)
    @objects = []
    @bg = new BackGround(6)
    @units = []
    @attack_points = []
    @ws = null

    @break  = new Break(BREAK_HEIGH, this, BREAK_WIDTH, 0)
    @break1 = new Break(BREAK_HEIGH, this, BREAK_WIDTH, 200)
    @break2 = new Break(BREAK_HEIGH, this, BREAK_WIDTH, -200)

    @width = 800
    @hieght = 400
    @arrow1 = new Arrow(ARROW_SIDE_LEFT, this)
    @arrow2 = new Arrow(ARROW_SIDE_RIGHT, this)
    @arrow1.stop()
    @arrow2.stop()
    new EventHandler this


  attackable: (position) ->
    if position > 200 - BREAK_HEIGH/2 and position < 200 + BREAK_HEIGH/2
      return true
    if position > -200 - BREAK_HEIGH/2 and position < -200 + BREAK_HEIGH/2
      return true
    if position > 0 - BREAK_HEIGH/2 and position < 0 + BREAK_HEIGH/2
      return true
    return false

  attackable_index: (arrow) ->
    position = arrow.get_position()
    w = arrow.get_half_heigh()
    w = 0
    if position > -200 - BREAK_HEIGH/2 + w and position < -200 + BREAK_HEIGH/2 - w
      return 1
    if position > 0 - BREAK_HEIGH/2 + w and position < 0 + BREAK_HEIGH/2 - w
      return 2
    if position > 200 - BREAK_HEIGH/2 + w and position < 200 + BREAK_HEIGH/2 - w
      return 3
    return 0

  break_offset: (index) ->
    if index == 1
      return @break2.get_offset()
    if index == 2
      return @break.get_offset()
    if index == 3
      return @break1.get_offset()

  move_break: (index, side) ->
    if index == 1
      return @break2.move(side)
    if index == 2
      return @break.move(side)
    if index == 3
      return @break1.move(side)

  gameover: (side) ->
    @arrow1.stop()
    @arrow2.stop()
    msg = "left win!"
    if side == 0
      msg = "left win!"
    else if side == 1
      msg = "right win!"
    @bar.render(msg, "success")

  half_width: () ->
    return 800

  half_height: () ->
    return 400

  hover: (pos) ->
    return

  select: (pos) ->
    console.log "pos"
    return

    #console.log("mmmmm")
    #alert("2")

  in_my_side: (pos) ->
    for unit in @units
      if unit.pos.x == pos.x and unit.pos.y == pos.y and unit.side == @my_side and @movable
        return true
    false

  player1Press: () ->
    position = @arrow1.get_position()
    @connector.shoot(position)

  syncPosition: (pos) ->
    @connector.sync(pos)


  player2Press: () ->
    return
    #@connector.shoot()

  player1Shoot: (pos) ->
    @arrow1.shoot(pos)

  player2Shoot: (pos) ->
    @arrow2.shoot(pos)

  player2Sync: (pos) ->
    console.log("sync@@@@@@@@@@" + pos)
    @arrow2.sync(pos)

  start_game: () ->
    @arrow1.start()
    @arrow2.start()

  render: () ->
    @canvas.clear()
    @bg.render(@canvas)
    @break.render @canvas
    @break1.render @canvas
    @break2.render @canvas
    @arrow1.render @canvas
    @arrow2.render @canvas
