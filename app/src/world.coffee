class World
  BREAK_WIDTH = 150
  BREAK_HEIGH = 100

  ARROW_SIDE_LEFT = 0
  ARROW_SIDE_RIGHT = 1

  constructor: (canvas, bar) ->
    @canvas = canvas
    @bar = bar
    @objects = []
    @board = new BackGround(6)
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

  init_units: (board_info) ->
    @units = []
    return
    @movable = board_info.movable
    @my_side = board_info.side
    for unit in board_info.Units
      @units.push new Unit(
        @board,
        unit.side,
        unit.value,
        {
          x: unit.pos.x,
          y: unit.pos.y
        }
      )

  hover: (pos) ->
    console.log "h"
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
    @arrow1.shoot()

  player2Press: () ->
    @arrow2.shoot()

  render: () ->
    @canvas.clear()
    @board.render(@canvas)
    @break.render @canvas
    @break1.render @canvas
    @break2.render @canvas
    @arrow1.render @canvas
    @arrow2.render @canvas
