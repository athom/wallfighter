class World
  WAITING = 0
  READY = 1
  RUNNING = 2
  OVER = 3
  DISCONNECTED = 4
  ROOM_ISFULL = 5
  SHOOT = 6
  BREAK_MOVED = 7
  LOSE = 8
  WIN = 9

  BREAK_WIDTH = 150
  BREAK_HEIGH = 100

  WOOD_MIDDLE = 0
  WOOD_LEFT_1 = 1
  WOOD_LEFT_2 = 2
  WOOD_RIGHT_1 = 3
  WOOD_RIGHT_2 = 4

  ARROW_SIDE_LEFT = 0
  ARROW_SIDE_RIGHT = 1

  constructor: (canvas, bar) ->
    @canvas = canvas
    @bar = bar
    @bg = new BackGround(6)

    @break2  = new Break(BREAK_HEIGH, this, BREAK_WIDTH, 0)
    @break3 = new Break(BREAK_HEIGH, this, BREAK_WIDTH, 200)
    @break1 = new Break(BREAK_HEIGH, this, BREAK_WIDTH, -200)

    @arrow1 = new Arrow(ARROW_SIDE_LEFT, this)
    @arrow2 = new Arrow(ARROW_SIDE_RIGHT, this)
    @arrow1.stop()
    @arrow2.stop()
    new EventHandler this


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

  shoot: () ->
    console.log("shoot!")
    msg = {
      Status: SHOOT
    }
    json_str = JSON.stringify(msg);
    @reactor.send(json_str)

  player1Press: () ->
    #position = @arrow1.get_position()
    @shoot()

  handle_close_event: () ->
    @bar.show_tip("你离线了", "danger")

  handle_event: (data) ->
    msg = JSON.parse(data);
    if msg.Status == ROOM_ISFULL
      @bar.show_tip("当前房间已满", "info")
      return
    if msg.Status == WAITING
      @bar.show_tip("已经连接服务器,正在匹配另一个玩家", "info")
      return
    if msg.Status == READY
      @bar.show_tip("已经匹配到对手, 3秒后开始, 请准备...", "info")
      @break1.reset()
      @break2.reset()
      @break3.reset()
      return
    if msg.Status == DISCONNECTED
      @bar.show_tip("对手离线了, 等待中...", "warning")
      return
    if msg.Status == WIN
      @bar.show_tip("Oyeah, 赢了", "success")
      side = 0
      if msg.Direction == "left_to_right"
        side = 0
      else
        side = 1
      if msg.WoodIndex == 1
        @break1.move(side)
      if msg.WoodIndex == 2
        @break2.move(side)
      if msg.WoodIndex == 3
        @break3.move(side)
      return
    if msg.Status == LOSE
      @bar.show_tip("Oooops, 输了", "danger")
      side = 0
      if msg.Direction == "left_to_right"
        side = 0
      else
        side = 1
      if msg.WoodIndex == 1
        @break1.move(side)
      if msg.WoodIndex == 2
        @break2.move(side)
      if msg.WoodIndex == 3
        @break3.move(side)
      return

    if msg.Status == BREAK_MOVED
      @bar.show_tip("专挑动了", "warning")
      console.log(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>")
      console.log(msg.Direction)
      side = 0
      if msg.Direction == "left_to_right"
        side = 0
      else
        side = 1
      if msg.WoodIndex == 1
        @break1.move(side)
      if msg.WoodIndex == 2
        @break2.move(side)
      if msg.WoodIndex == 3
        @break3.move(side)

        # body...
      #if msg.GateWood.XPos == WOOD_LEFT_1
        # body...
      #msg.
      return
    if msg.Status == RUNNING
      @bar.show_tip("火暴PK中...", "info")
    @arrow1.set_position(msg.XPos, msg.YPos)
    @arrow2.set_position(-msg.OtherXPos, msg.OtherYPos)
    #@arrow2.start()

  set_reactor: (reactor) ->
    @reactor = reactor

  render: () ->
    @canvas.clear()
    @bg.render(@canvas)
    @break1.render @canvas
    @break2.render @canvas
    @break3.render @canvas
    @arrow1.render @canvas
    @arrow2.render @canvas
