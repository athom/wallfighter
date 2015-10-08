class Connector
  constructor: (bar) ->
    @bar = bar
    @ping_token = Math.random().toString(36).substr(2)
    @room_token = ""
    @mathing = false
    @yunba_init()

  set_world: (w) ->
    @world = w

  yunba_init: () ->
    @yunba = new Yunba({appkey: '52fcc04c4dc903d66d6f8f92'})
    @yunba.init (success) =>
      if success
        @connecting()
      else
        @bar.show_tip("server init failed", "danger")
    @yunba.set_message_cb (data) =>
      @_on_msg_incoming(data)


  connecting: () ->
    @yunba.connect (success, msg) =>
      if success
        @on_connected()
      else
        @bar.show_tip("connecting server failed", "danger")

  on_connected: () ->
    console.log("Yahoo 2!")
    @bar.show_tip("已经连接服务器,正在匹配另一个玩家", "info")
    @subscribe("all")
    @subscribe(@ping_token)
    @_send_msg("all", @ping_token)

  subscribe: (topic) ->
    @yunba.subscribe {'topic' : topic}, (success, msg)=>
      if success
        console.log("subscribed ok")
      else
        @bar.show_tip("subscribe topic (" + topic + ") failed", "danger")

  do_unsubscribe: (topic) ->
    @yunba.unsubscribe {'topic' : topic}, (success, msg)=>
      if success
        console.log("unsubscribed ok")
      else
        @bar.show_tip("unsubscribe topic (" + topic + ") failed", "danger")


  on_matched: () ->
    @bar.show_tip("PK中...", "info")
    @_send_msg(@room_token, "start")
    #bar = @bar
    #trigger = ->
      ##@on_playing()
    #step1 = ->
      #bar.show_tip("后台已经您匹配到另一个玩家                1", "info")
      #setTimeout trigger, 1000
    #step2 = ->
      #bar.show_tip("后台已经您匹配到另一个玩家                2", "info")
      #setTimeout step1, 1000
    #step3 = ->
      #bar.show_tip("后台已经您匹配到另一个玩家                3", "info")
      #setTimeout step2, 1000
    #setTimeout step3, 1000

  on_playing: () ->
    @bar.show_tip("PK中...", "info")
    @_send_msg(@room_token, "start")

  on_gameover: () ->

  on_disconnected: () ->

  singal_find_matcher: () ->

  singal_find_matcher: () ->

  _on_msg_incoming: (data) ->
    console.log("incoming:")
    console.log(data)
    console.log("ping_token: " + @ping_token)
    console.log("room_token: " + @room_token)
    if data.topic == "all"
      return @on_msg_all(data.msg)
    if @room_token != "" and data.topic == @room_token
      if data.msg == "ping"
        return @on_msg_mathing_ping()
      if data.msg == "pong"
        return @on_msg_mathing_pong()
      if data.msg == "start"
        return @on_msg_gaming_start()
      if !!data.msg.match(/sync:/)
        return @on_msg_gaming_sync(data.msg)
      return @on_msg_gaming_shoot(data.msg)
    if data.topic == @ping_token
      if data.msg == "ping"
        return @on_msg_mathing_ping()

  shoot: (pos) ->
    @_send_msg(@room_token, "shoot:"+@ping_token+":"+pos)

  sync: (pos) ->
    @_send_msg(@room_token, "sync:"+@ping_token+":"+pos)

  _send_msg: (topic, msg) ->
    @yunba.publish {
      'topic': topic,
      'msg': msg
    }, (success, msg) =>
      if success
        console.log("sent " + msg)
      else
        @bar.show_tip("sent msg (" + msg ") error", "danger")

  on_msg_all: (msg) ->
    return if msg == @ping_token
    return if @mathing
    @mathing = true
    # 后来者发起
    @room_token = msg
    @subscribe(@room_token)
    @_send_msg(@room_token, "ping")
    console.log("all incoming:")
    console.log(msg)

  on_msg_mathing_ping: () ->
    console.log("ping incoming:")
    @room_token = @ping_token if @room_token == ""
    @_send_msg(@room_token, "pong")
    @do_unsubscribe("all")
    @on_matched()

  on_msg_mathing_pong: () ->
    console.log("pong incoming:")
    @do_unsubscribe("all")
    @on_matched()
    #@do_unsubscribe(@ping_token)

  on_msg_gaming_start: () ->
    @world.start_game()

  on_msg_gaming_sync: (msg) ->
    a = msg.split(":")
    if !a or a.length != 3
      console.log("ERROR: shoot msg format failed")
      return
    shooter = a[1]
    shooter = a[1]
    pos = parseInt(a[2])
    if shooter == @ping_token
      #@world.player1Shoot(pos)
    else
      @world.player2Sync(pos)

  on_msg_gaming_shoot: (msg) ->
    console.log("------------------------------------------------>")
    console.log(msg)
    a = msg.split(":")
    if !a or a.length != 3
      console.log("ERROR: shoot msg format failed")
      return
    shooter = a[1]
    pos = parseInt(a[2])
    if shooter == @ping_token
      @world.player1Shoot(pos)
    else
      @world.player2Shoot(pos)
