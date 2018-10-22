// Generated by CoffeeScript 1.6.3
(function() {
  var Arrow, BackGround, Border, Break, Canvas, EventHandler, HEIGHT, OFFSET, StatusBar, WIDTH, Wall, Websocket, World, getCanvas, getRatio, main, setRatio;

  Arrow = (function() {
    var COLOR_ARROW, CYCLE_COUNT, HEIGHT, OFFSET, SIDE_LEFT, SIDE_RIGHT, V_FAST, V_MIDDLE, V_SLOW, WIDTH;

    COLOR_ARROW = 'RGBA(464, 224, 126, 0.7)';

    WIDTH = 200;

    HEIGHT = 20;

    SIDE_LEFT = 0;

    SIDE_RIGHT = 1;

    OFFSET = 500;

    V_SLOW = 5;

    V_MIDDLE = 5;

    V_FAST = 5;

    CYCLE_COUNT = 800;

    function Arrow(side, world) {
      this.side = side;
      this.world = world;
      this.position = 0;
      this.position_x = 0;
      this.v = V_MIDDLE;
      this.cycle = 0;
      this.offset = 0;
      this.protecting_section_index = 0;
    }

    Arrow.prototype.get_offset = function() {
      if (this.side === SIDE_LEFT) {
        return this.offset - OFFSET;
      }
      if (this.side === SIDE_RIGHT) {
        return this.offset + OFFSET;
      }
    };

    Arrow.prototype.set_position = function(x, y) {
      var ratio, ratio_x;
      ratio = this.world.half_height() / 1000.0;
      this.origin_position = y;
      this.position = y * ratio;
      ratio_x = OFFSET / 2 / 1000.0;
      return this.offset = x * ratio_x;
    };

    Arrow.prototype.get_position = function() {
      return this.origin_position;
    };

    Arrow.prototype.get_direction = function() {
      var v;
      v = Math.abs(this.v);
      return this.v / v;
    };

    Arrow.prototype.get_half_heigh = function() {
      return HEIGHT / 2;
    };

    Arrow.prototype.shoot = function(pos) {
      var index;
      index = this.world.attackable_index(this);
      if (index !== 0 && index === this.protecting_section_index) {

      }
    };

    Arrow.prototype.stop = function() {
      return this.halt = true;
    };

    Arrow.prototype.start = function() {
      return this.halt = false;
    };

    Arrow.prototype.render = function(canvas) {
      var offset;
      offset = this.get_offset();
      return canvas.fillRect(COLOR_ARROW, {
        x: offset - WIDTH / 2,
        y: this.position - HEIGHT / 2,
        w: WIDTH,
        h: HEIGHT
      });
    };

    return Arrow;

  })();

  BackGround = (function() {
    var COLOR_ATTACK, COLOR_BORDER, COLOR_LINE, HEIGHT, WALL_WIDTH, WIDTH;

    WIDTH = 1600;

    HEIGHT = 800;

    WALL_WIDTH = 150;

    COLOR_BORDER = 'RGB(100, 0, 240)';

    COLOR_LINE = 'RGB(100, 0, 240)';

    COLOR_ATTACK = 'RGBA(264, 224, 126, 0.4)';

    function BackGround(size) {
      this.size = size;
      this.border = new Border;
      this.wall = new Wall(HEIGHT, WALL_WIDTH);
    }

    BackGround.prototype.render = function(canvas) {
      var heightUnit, i, widthUnit, x1, y1, _i, _ref, _results;
      this.border.render(canvas);
      this.wall.render(canvas);
      return;
      widthUnit = WIDTH / this.size;
      heightUnit = HEIGHT / this.size;
      _results = [];
      for (i = _i = 1, _ref = this.size; 1 <= _ref ? _i < _ref : _i > _ref; i = 1 <= _ref ? ++_i : --_i) {
        i = i - this.size / 2;
        x1 = i * widthUnit;
        y1 = i * heightUnit;
        canvas.drawLine(COLOR_BORDER, x1, -HEIGHT / 2, x1, HEIGHT / 2);
        _results.push(canvas.drawLine(COLOR_BORDER, -HEIGHT / 2, y1, HEIGHT / 2, y1));
      }
      return _results;
    };

    return BackGround;

  })();

  Border = (function() {
    var COLOR_ATTACK, COLOR_BORDER, COLOR_LINE, HEIGHT, WIDTH;

    WIDTH = 1600;

    HEIGHT = 800;

    COLOR_BORDER = 'RGB(100, 0, 240)';

    COLOR_LINE = 'RGB(100, 0, 240)';

    COLOR_ATTACK = 'RGBA(264, 224, 126, 0.4)';

    function Border() {}

    Border.prototype.render = function(canvas) {
      return canvas.drawRect(COLOR_BORDER, {
        x: -WIDTH / 2,
        y: -HEIGHT / 2,
        w: WIDTH,
        h: HEIGHT
      });
    };

    return Border;

  })();

  Break = (function() {
    var COLOR_BREAK, DANGER_LEFT, DANGER_LEFT_2, DANGER_LEFT_3, DANGER_MIDDLE, DANGER_RIGHT, DANGER_RIGHT_2, DANGER_RIGHT_3, PUSH_FROM_LEFT, PUSH_FROM_RIGHT;

    COLOR_BREAK = 'RGB(100, 250, 240)';

    PUSH_FROM_LEFT = 0;

    PUSH_FROM_RIGHT = 1;

    DANGER_MIDDLE = 0;

    DANGER_LEFT = -1;

    DANGER_LEFT_2 = -2;

    DANGER_LEFT_3 = -3;

    DANGER_RIGHT = 1;

    DANGER_RIGHT_2 = 2;

    DANGER_RIGHT_3 = 3;

    function Break(height, world, width, position) {
      this.world = world;
      this.height = height;
      this.width = width;
      this.position = position;
      this.danger = DANGER_MIDDLE;
      this.is_falling = false;
    }

    Break.prototype.get_offset = function() {
      var delta;
      delta = 2 * this.width / 3;
      if (this.danger === DANGER_MIDDLE) {
        return 0;
      }
      if (this.danger === DANGER_LEFT) {
        return -1 * delta;
      }
      if (this.danger === DANGER_LEFT_2) {
        return -2 * delta;
      }
      if (this.danger === DANGER_LEFT_3) {
        return -3 * delta;
      }
      if (this.danger === DANGER_RIGHT) {
        return 1 * delta;
      }
      if (this.danger === DANGER_RIGHT_2) {
        return 2 * delta;
      }
      if (this.danger === DANGER_RIGHT_3) {
        return 3 * delta;
      }
    };

    Break.prototype.reset = function() {
      return this.danger = DANGER_MIDDLE;
    };

    Break.prototype.move = function(side) {
      if (side === PUSH_FROM_LEFT) {
        this.danger += 1;
      } else if (side === PUSH_FROM_RIGHT) {
        this.danger -= 1;
      }
      if (this.danger === DANGER_LEFT_3) {
        this.is_falling = true;
        return this.world.gameover(PUSH_FROM_RIGHT);
      } else if (this.danger === DANGER_RIGHT_3) {
        this.is_falling = true;
        return this.world.gameover(PUSH_FROM_LEFT);
      }
    };

    Break.prototype.render = function(canvas) {
      var field, offset;
      if (this.is_falling) {
        if (this.danger === DANGER_LEFT_3 || this.danger === DANGER_RIGHT_3) {
          this.position += 5;
        }
        if (this.position >= this.world.half_height() - 50) {
          this.is_falling = false;
        }
      }
      offset = this.get_offset();
      field = {
        x: offset - this.width,
        y: this.position - this.height / 2,
        w: this.width * 2,
        h: this.height
      };
      return canvas.fillRect(COLOR_BREAK, field);
    };

    return Break;

  })();

  Canvas = function(ctx, w, h) {
    this.ctx = ctx;
    this.w = w;
    return this.h = h;
  };

  Canvas.prototype.fillRect = function(color, rect) {
    this.ctx.fillStyle = color;
    return this.ctx.fillRect(this.xscreen(rect.x), this.yscreen(rect.y), rect.w, rect.h);
  };

  Canvas.prototype.drawRect = function(color, rect) {
    this.ctx.strokeStyle = color;
    return this.ctx.strokeRect(this.xscreen(rect.x), this.yscreen(rect.y), rect.w, rect.h);
  };

  Canvas.prototype.drawLine = function(color, sx, sy, ex, ey) {
    this.ctx.strokeStyle = color;
    this.ctx.beginPath();
    this.ctx.moveTo(this.xscreen(sx), this.yscreen(sy));
    this.ctx.lineTo(this.xscreen(ex), this.yscreen(ey));
    return this.ctx.stroke();
  };

  Canvas.prototype.drawArc = function(color, x, y, r, sAngle, eAngle) {
    this.ctx.strokeStyle = color;
    this.ctx.beginPath();
    this.ctx.arc(this.xscreen(x), this.yscreen(y), r, sAngle, eAngle);
    return this.ctx.stroke();
  };

  Canvas.prototype.fillArc = function(color, x, y, r, sAngle, eAngle) {
    this.ctx.fillStyle = color;
    this.ctx.beginPath();
    this.ctx.arc(this.xscreen(x), this.yscreen(y), r, sAngle, eAngle);
    return this.ctx.fill();
  };

  Canvas.prototype.drawCircle = function(color, x, y, r) {
    return this.drawArc(color, x, y, r, 0, 2 * Math.PI);
  };

  Canvas.prototype.fillCircle = function(color, x, y, r) {
    return this.fillArc(color, x, y, r, 0, 2 * Math.PI);
  };

  Canvas.prototype.drawText = function(color, font, text, x, y) {
    this.ctx.fillStyle = color;
    this.ctx.font = font;
    x = x - this.ctx.measureText(text).width / 2;
    return this.ctx.fillText(text, this.xscreen(x), this.yscreen(y));
  };

  Canvas.prototype.clear = function() {
    return this.ctx.clearRect(0, 0, this.w, this.h);
  };

  Canvas.prototype.xscreen = function(x) {
    return x + this.w / 2;
  };

  Canvas.prototype.yscreen = function(y) {
    return y + this.h / 2;
  };

  EventHandler = (function() {
    function EventHandler(world) {
      var listener;
      listener = new window.keypress.Listener();
      listener.simple_combo("space", function() {
        return world.player1Press();
      });
    }

    return EventHandler;

  })();

  WIDTH = 1600.0;

  HEIGHT = 1000.0;

  OFFSET = 150;

  getRatio = function() {
    var h, height, ratio, ratioh, ratiow, w, width;
    width = WIDTH;
    height = HEIGHT;
    w = window.innerWidth;
    h = window.innerHeight - OFFSET;
    ratiow = w / width;
    ratioh = h / height;
    if (ratiow < ratioh) {
      ratio = ratiow;
    } else {
      ratio = ratioh;
    }
    return ratio;
  };

  setRatio = function(width, height) {
    var c, ratio, ratioh, ratiow;
    c = document.getElementById("chess-board");
    c.width = window.innerWidth;
    c.height = window.innerHeight - OFFSET;
    ratiow = c.width / width;
    ratioh = c.height / height;
    if (ratiow < ratioh) {
      ratio = ratiow;
      c.height = height * ratio;
    } else {
      ratio = ratioh;
      c.width = width * ratio;
    }
    return ratio;
  };

  getCanvas = function() {
    var c, ctx, height, ratio, width;
    width = WIDTH;
    height = HEIGHT;
    c = document.getElementById("chess-board");
    ctx = c.getContext("2d");
    ratio = setRatio(width, height);
    ctx.scale(ratio, ratio);
    return new Canvas(ctx, width, height);
  };

  main = function() {
    var canvas, status_bar, world, ws;
    canvas = getCanvas();
    status_bar = new StatusBar;
    world = new World(canvas, status_bar);
    ws = new Websocket(world);
    world.set_reactor(ws);
    ws.connect();
    return setInterval(function() {
      return world.render();
    });
  };

  $(function() {
    return main();
  });

  StatusBar = (function() {
    function StatusBar() {}

    StatusBar.prototype.clear_class = function() {
      $("#status-bar").removeClass("alert-info");
      $("#status-bar").removeClass("alert-success");
      $("#status-bar").removeClass("alert-warning");
      return $("#status-bar").removeClass("alert-danger");
    };

    StatusBar.prototype.show_tip = function(text, klass) {
      this.clear_class();
      $("#status-bar").addClass("alert-" + klass);
      return $("#status-bar").html(text);
    };

    return StatusBar;

  })();

  Wall = (function() {
    var COLOR_WALL;

    COLOR_WALL = 'RGB(100, 0, 240)';

    function Wall(height, width) {
      this.height = height;
      this.width = width;
    }

    Wall.prototype.render = function(canvas) {
      canvas.drawLine(COLOR_WALL, -this.width, -this.height / 2, -this.width, this.height / 2);
      return canvas.drawLine(COLOR_WALL, this.width, -this.height / 2, this.width, this.height / 2);
    };

    return Wall;

  })();

  Websocket = (function() {
    var WS_HOST;

    WS_HOST = "ws://localhost:3000";

    WS_HOST = "ws://115.159.44.225:3000";

    WS_HOST = "ws://119.28.1.61:3000";

    function Websocket(event_hadler) {
      this.set_slug_and_url();
      this.ws_conn = null;
      this.event_hadler = event_hadler;
    }

    Websocket.prototype.random_slug = function() {
      return (Math.floor(Math.random() * 1000) + 1000).toString();
    };

    Websocket.prototype.set_slug_and_url = function() {
      var array, currentUrl;
      currentUrl = window.location.href;
      console.log(currentUrl);
      array = currentUrl.split("?room=");
      if (array.length < 2) {
        this.slug = this.random_slug();
        return currentUrl += "?room=" + this.slug;
      } else {
        return this.slug = array[1];
      }
    };

    Websocket.prototype.connect = function() {
      var self, _action, _event_hadler, _reconnect;
      if (this.ws_conn !== null) {
        console.log("connected");
        return;
      }
      console.log("connecting");
      _event_hadler = this.event_hadler;
      _reconnect = this.reconnect;
      self = this;
      _action = function() {
        self.ws_conn = null;
        return self.connect();
      };
      this.ws_conn = new WebSocket(WS_HOST + "/ws/" + this.slug);
      this.ws_conn.onopen = function(data) {
        console.log("opened");
        return console.log(data);
      };
      this.ws_conn.onmessage = function(msg_event) {
        var data;
        data = msg_event.data;
        return _event_hadler.handle_event(data);
      };
      this.ws_conn.onclose = function(data) {
        return _event_hadler.handle_close_event();
      };
      return this.ws_conn.onerror = function(data) {
        return alert("error");
      };
    };

    Websocket.prototype.reconnect_action = function() {
      this.ws_conn = null;
      return this.connect();
    };

    Websocket.prototype.reconnect = function(action) {
      return setTimeout(action, Math.floor(Math.random() * 5001) + 1000);
    };

    Websocket.prototype.send = function(data) {
      return this.ws_conn.send(data);
    };

    return Websocket;

  })();

  World = (function() {
    var ARROW_SIDE_LEFT, ARROW_SIDE_RIGHT, BREAK_HEIGH, BREAK_MOVED, BREAK_WIDTH, DISCONNECTED, LOSE, OVER, READY, ROOM_ISFULL, RUNNING, SHOOT, WAITING, WIN, WOOD_LEFT_1, WOOD_LEFT_2, WOOD_MIDDLE, WOOD_RIGHT_1, WOOD_RIGHT_2;

    WAITING = 0;

    READY = 1;

    RUNNING = 2;

    OVER = 3;

    DISCONNECTED = 4;

    ROOM_ISFULL = 5;

    SHOOT = 6;

    BREAK_MOVED = 7;

    LOSE = 8;

    WIN = 9;

    BREAK_WIDTH = 150;

    BREAK_HEIGH = 100;

    WOOD_MIDDLE = 0;

    WOOD_LEFT_1 = 1;

    WOOD_LEFT_2 = 2;

    WOOD_RIGHT_1 = 3;

    WOOD_RIGHT_2 = 4;

    ARROW_SIDE_LEFT = 0;

    ARROW_SIDE_RIGHT = 1;

    function World(canvas, bar) {
      this.canvas = canvas;
      this.bar = bar;
      this.bg = new BackGround(6);
      this.break2 = new Break(BREAK_HEIGH, this, BREAK_WIDTH, 0);
      this.break3 = new Break(BREAK_HEIGH, this, BREAK_WIDTH, 200);
      this.break1 = new Break(BREAK_HEIGH, this, BREAK_WIDTH, -200);
      this.arrow1 = new Arrow(ARROW_SIDE_LEFT, this);
      this.arrow2 = new Arrow(ARROW_SIDE_RIGHT, this);
      this.arrow1.stop();
      this.arrow2.stop();
      new EventHandler(this);
    }

    World.prototype.gameover = function(side) {
      var msg;
      this.arrow1.stop();
      this.arrow2.stop();
      msg = "left win!";
      if (side === 0) {
        msg = "left win!";
      } else if (side === 1) {
        msg = "right win!";
      }
      return this.bar.render(msg, "success");
    };

    World.prototype.half_width = function() {
      return 800;
    };

    World.prototype.half_height = function() {
      return 400;
    };

    World.prototype.shoot = function() {
      var json_str, msg;
      console.log("shoot!");
      msg = {
        Status: SHOOT
      };
      json_str = JSON.stringify(msg);
      return this.reactor.send(json_str);
    };

    World.prototype.player1Press = function() {
      return this.shoot();
    };

    World.prototype.handle_close_event = function() {
      return this.bar.show_tip("你离线了", "danger");
    };

    World.prototype.handle_event = function(data) {
      var msg, side;
      msg = JSON.parse(data);
      if (msg.Status === ROOM_ISFULL) {
        this.bar.show_tip("当前房间已满", "info");
        return;
      }
      if (msg.Status === WAITING) {
        this.bar.show_tip("已经连接服务器,正在匹配另一个玩家", "info");
        return;
      }
      if (msg.Status === READY) {
        this.bar.show_tip("已经匹配到对手, 3秒后开始, 请准备...", "info");
        this.break1.reset();
        this.break2.reset();
        this.break3.reset();
        return;
      }
      if (msg.Status === DISCONNECTED) {
        this.bar.show_tip("对手离线了, 等待中...", "warning");
        return;
      }
      if (msg.Status === WIN) {
        this.bar.show_tip("Oyeah, 赢了", "success");
        side = 0;
        if (msg.Direction === "left_to_right") {
          side = 0;
        } else {
          side = 1;
        }
        if (msg.WoodIndex === 1) {
          this.break1.move(side);
        }
        if (msg.WoodIndex === 2) {
          this.break2.move(side);
        }
        if (msg.WoodIndex === 3) {
          this.break3.move(side);
        }
        return;
      }
      if (msg.Status === LOSE) {
        this.bar.show_tip("Oooops, 输了", "danger");
        side = 0;
        if (msg.Direction === "left_to_right") {
          side = 0;
        } else {
          side = 1;
        }
        if (msg.WoodIndex === 1) {
          this.break1.move(side);
        }
        if (msg.WoodIndex === 2) {
          this.break2.move(side);
        }
        if (msg.WoodIndex === 3) {
          this.break3.move(side);
        }
        return;
      }
      if (msg.Status === BREAK_MOVED) {
        this.bar.show_tip("专挑动了", "warning");
        console.log(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
        console.log(msg.Direction);
        side = 0;
        if (msg.Direction === "left_to_right") {
          side = 0;
        } else {
          side = 1;
        }
        if (msg.WoodIndex === 1) {
          this.break1.move(side);
        }
        if (msg.WoodIndex === 2) {
          this.break2.move(side);
        }
        if (msg.WoodIndex === 3) {
          this.break3.move(side);
        }
        return;
      }
      if (msg.Status === RUNNING) {
        this.bar.show_tip("火暴PK中...", "info");
      }
      this.arrow1.set_position(msg.XPos, msg.YPos);
      return this.arrow2.set_position(-msg.OtherXPos, msg.OtherYPos);
    };

    World.prototype.set_reactor = function(reactor) {
      return this.reactor = reactor;
    };

    World.prototype.render = function() {
      this.canvas.clear();
      this.bg.render(this.canvas);
      this.break1.render(this.canvas);
      this.break2.render(this.canvas);
      this.break3.render(this.canvas);
      this.arrow1.render(this.canvas);
      return this.arrow2.render(this.canvas);
    };

    return World;

  })();

}).call(this);

/*
//@ sourceMappingURL=app.map
*/
