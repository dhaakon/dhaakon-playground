// Generated by CoffeeScript 1.6.3
(function() {
  var Backbone, Redis, Router, Routes, Server, SocketServer, r, server,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  Backbone = require('backbone');

  Redis = (function() {
    Redis.prototype.redis = require('redis');

    Redis.prototype.url = require('url');

    Redis.prototype.redisURL = null;

    Redis.prototype.client = null;

    function Redis() {
      this.createRedis();
    }

    Redis.prototype.createRedis = function() {
      var _u;
      _u = process.env.REDISCLOUD_URL || 'redis://rediscloud:F8OKh6ZcKmKKXbsE@pub-redis-15625.eu-west-1-1.2.ec2.garantiadata.com:15625';
      this.redisURL = this.url.parse(_u);
      this.client = this.redis.createClient(this.redisURL.port, this.redisURL.hostname, {
        o_ready_check: true
      });
      this.client.auth(this.redisURL.auth.split(":")[1]);
      return this.client.on('error', function(err) {
        return console.log('Error' + err);
      });
    };

    return Redis;

  })();

  Router = require('./routes/routes.js');

  Routes = (function() {
    function Routes() {
      this.routes = new Backbone.Collection();
    }

    return Routes;

  })();

  r = new Routes();

  SocketServer = (function() {
    function SocketServer(app, redis) {
      this.app = app;
      this.redis = redis;
      this.onConnectionHandler = __bind(this.onConnectionHandler, this);
      this.socket = this.app;
      this.createSocket();
    }

    SocketServer.prototype.createSocket = function() {
      return this.socket.io.sockets.on('connection', this.onConnectionHandler);
    };

    SocketServer.prototype.createRoutes = function() {
      var _this = this;
      this.app.io.route('serverStarted', function(req) {
        _this.redis.client.get('keys', function(err, resp) {
          var obj;
          obj = JSON.stringify(resp);
          return _this.socket.io.sockets.emit('locationsLoaded', obj);
        });
        return _this.redis.client.get('facebook', function(err, resp) {
          var obj;
          obj = JSON.stringify(resp);
          return _this.socket.io.sockets.emit('facebookLoaded', obj);
        });
      });
      this.app.io.route('gps', function(req) {
        var uid;
        _this.socket.io.sockets.emit('receiveResponse', req.data);
        uid = Math.random().toString(36).substr(2, 9);
        _this.redis.get;
        return _this.redis.client.get('keys', function(err, resp) {
          var keys, obj;
          obj = JSON.stringify(req.data);
          keys = JSON.parse(resp) || {
            locations: []
          };
          keys.locations.push(obj);
          return _this.redis.client.set('keys', JSON.stringify(keys));
        });
      });
      return this.app.io.route('facebook', function(req) {
        return _this.redis.client.get('facebook', function(err, resp) {
          var a, b, keys, o, obj;
          obj = req.data;
          keys = JSON.parse(resp) || {
            locations: []
          };
          console.log(keys);
          if (keys) {
            for (o in keys.locations) {
              a = keys.locations[o].id;
              b = JSON.parse(obj).id;
              if (a === b) {
                return;
              }
            }
          }
          keys.locations.push(obj);
          return _this.redis.client.set('facebook', JSON.stringify(keys));
        });
      });
    };

    SocketServer.prototype.onConnectionHandler = function(socket) {
      this.createRoutes();
      return socket.emit('location');
    };

    SocketServer.prototype.onGPSHandler = function(event) {};

    return SocketServer;

  })();

  Server = (function() {
    Server.prototype.express = require('express.io');

    Server.prototype.path = require('path');

    Server.prototype.app = null;

    Server.prototype.server = null;

    Server.prototype.routes = null;

    Server.prototype.redis = null;

    function Server() {
      this.app = this.express();
      this.setUpExpress();
      this.createServer();
    }

    Server.prototype.setUpExpress = function() {
      this.app.set('port', process.env.PORT || 3000);
      this.app.set('views', this.path.join(__dirname, 'views'));
      this.app.set('view engine', 'jade');
      this.app.set('view options', {
        pretty: true
      });
      this.app.use(this.express.favicon());
      this.app.use(this.express.logger('dev'));
      this.app.use(this.express.json());
      this.app.use(this.express.urlencoded());
      this.app.use(this.express.methodOverride());
      this.app.use(this.app.router);
      return this.app.use(this.express["static"](this.path.join(__dirname + '/', 'public')));
    };

    Server.prototype.setUpRoutes = function() {
      this.app.get('/', Router.index);
      this.app.get('/users', Router.list);
      this.app.get('/demos/:type', Router.demos);
      this.app.get('/maps/:renderer', Router.map);
      this.app.get('/codem', Router.codem);
      this.app.get('/loaders', Router.loaders);
      this.app.get('/tgsData', Router.thinkData);
      this.app.get('/tgs/:role', Router.tgs);
      this.app.get('/tgs-facebook/', Router.facebook);
      this.app.get('/location/:lat/:long', Router.getlocation);
      this.app.get('/students/', Router.getstudents);
      this.app.get('/faculty/', Router.getfaculty);
      this.app.get('/tgslocations/', Router.tgslocations);
      this.app.get('/tgs-dual/', Router.dual);
      this.app.get('/d3/:type/', Router.d3);
      this.app.post('/tgs-facebook/', function(request, response) {
        return response.redirect('/tgs-facebook/');
      });
      if ('development' === this.app.get('env')) {
        return this.app.use(this.express.errorHandler());
      }
    };

    Server.prototype.createServer = function() {
      this.app.http().io();
      this.setUpRoutes();
      return this.app.listen(this.app.get('port'));
    };

    return Server;

  })();

  server = server || new Server();

}).call(this);
