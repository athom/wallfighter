class Websocket
  WS_HOST = "ws://localhost:3000"
  WS_HOST = "ws://115.159.44.225:3000"
  #WS_HOST = "ws://ec2-52-74-37-229.ap-southeast-1.compute.amazonaws.com:3000"

  constructor: (event_hadler) ->
    @set_slug_and_url()
    @ws_conn = null
    @event_hadler = event_hadler

  random_slug: () ->
    (Math.floor(Math.random()*1000) + 1000).toString()

  set_slug_and_url: () ->
    currentUrl = window.location.href
    console.log(currentUrl)
    array = currentUrl.split "?room="
    if array.length < 2
      @slug = @random_slug()
      currentUrl += "?room=" + @slug
    else
      @slug = array[1]
      #window.history.pushState({},0,currentUrl);


  connect: () ->
    if @ws_conn != null
      console.log "connected"
      return
    console.log "connecting"

    _event_hadler = @event_hadler
    _reconnect = @reconnect
    self = this
    _action = () ->
      self.ws_conn = null
      self.connect()

    @ws_conn = new WebSocket(WS_HOST + "/ws/" + @slug);
    @ws_conn.onopen = (data) ->
      console.log "opened"
      console.log data

    @ws_conn.onmessage = (msg_event) ->
      data = msg_event.data
      _event_hadler.handle_event data

    @ws_conn.onclose = (data) ->
      _event_hadler.handle_close_event()

    @ws_conn.onerror = (data) ->
      alert "error"


  reconnect_action: () ->
    @ws_conn = null
    @connect()

  reconnect: (action) ->
    #debugger
    setTimeout(action, Math.floor(Math.random() * 5001) + 1000);



  send: (data) ->
    @ws_conn.send(data)
