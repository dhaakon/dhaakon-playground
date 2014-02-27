// Generated by CoffeeScript 1.6.3
(function() {
  var Booking, BookingInformation, Config, EventManager, Events, Graphics, Map, SocketClient, TGS,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    _this = this;

  Config = window.Config = {
    Graphics: {
      Colors: {
        location: 'red',
        grade: {
          9: 'blue',
          10: 'orange',
          11: 'orange',
          12: 'brown'
        },
        faculty: 'yellow'
      }
    },
    display: {
      Settings: {
        jsonPath: '/json/world.json',
        csvPath: '/csv/booking_small.csv',
        renderer: 'canvas',
        hasGrid: false,
        hasRotation: false,
        hasLines: false
      },
      Map: {
        container: '#map-container',
        height: null,
        width: null,
        scale: 350,
        xOffset: 0,
        yOffset: 0,
        scaleMin: 0.75,
        scaleMax: 10,
        projections: ['stereographic', 'orthographic', 'mercator', 'gnomonic', 'equirectangular', 'conicEquidistant', 'conicConformal', 'conicEqualArea', 'azimuthalEquidistant', 'azimuthalEqualArea', 'albersUsa', 'transverseMercator'],
        projectionKey: 4,
        markerSize: 2,
        rotation: [0, -15],
        velocity: 20
      }
    },
    user: {
      Settings: {
        jsonPath: '/json/world.json',
        csvPath: '/csv/booking_small.csv',
        renderer: 'canvas',
        hasGrid: false,
        hasRotation: false,
        hasLines: false
      },
      Map: {
        container: '#map-container',
        height: null,
        width: null,
        scale: 350,
        xOffset: 0,
        yOffset: 0,
        scaleMin: 0.75,
        scaleMax: 10,
        projections: ['stereographic', 'orthographic', 'mercator', 'gnomonic', 'equirectangular', 'conicEquidistant', 'conicConformal', 'conicEqualArea', 'azimuthalEquidistant', 'azimuthalEqualArea', 'albersUsa', 'transverseMercator'],
        projectionKey: 4,
        markerSize: 2,
        rotation: [0, -15],
        velocity: 20
      }
    },
    TGS: {
      src: '/tgslocations/',
      students_src: '/students/',
      faculty_src: '/faculty/'
    },
    FACEBOOK: {
      location: 'http://graph.facebook.com/'
    }
  };

  Graphics = {
    Star: {
      shape: 'polygon',
      points: ''
    },
    Pin: {
      Needle: {
        shape: 'path',
        d: null,
        gradient: {
          type: 'linear',
          x1: 0,
          x2: 0,
          y1: 0,
          y2: 0
        }
      },
      Ball: {
        shape: 'circle',
        rx: null,
        ry: null,
        gradient: {
          type: 'radial',
          cx: 0,
          cy: 0,
          fx: 0,
          fy: 0,
          r: 0
        }
      }
    }
  };

  BookingInformation = (function() {
    BookingInformation.prototype.$tourTitle = null;

    BookingInformation.prototype.$bookerCityTitle = null;

    BookingInformation.prototype.$tourCityTitle = null;

    function BookingInformation() {
      this.init();
    }

    BookingInformation.prototype.init = function() {
      this.$tourCityTitle = $('#tour-city');
      this.$bookerCityTitle = $('#booker-city');
      return this.$tourTitle = $('#tour-title');
    };

    BookingInformation.prototype.changeTourTitle = function(text) {
      return this.$tourTitle.find('span').html(text);
    };

    BookingInformation.prototype.changeTourCityTitle = function(text) {
      return this.$tourCityTitle.find('span').html(text);
    };

    BookingInformation.prototype.changeBookerCityTitle = function(text) {
      return this.$bookerCityTitle.find('span').html(text);
    };

    return BookingInformation;

  })();

  Booking = (function() {
    function Booking(src) {
      this.src = src;
      this.onBookingLoaded = __bind(this.onBookingLoaded, this);
      this.createBooking();
    }

    Booking.prototype.createBooking = function() {
      return d3.csv(this.src, this.onBookingLoaded);
    };

    Booking.prototype.onBookingLoaded = function(error, data) {
      this.data = data;
      return EventManager.emitEvent(Events.BOOKING_LOADED);
    };

    return Booking;

  })();

  window.EventManager = EventManager = new EventEmitter();

  window.Events = Events = {
    MAP_LOADED: 'onMapLoaded',
    BOOKING_LOADED: 'onBookingLoaded',
    MARKER_FOCUS: 'onMarkerFocus',
    MAP_CLICKED: 'onMapClicked',
    SERVER_UPDATED: 'onServerUpdated',
    SERVER_STARTED: 'onServerStarted',
    SOCKET_CONNECTED: 'onSocketConnected',
    ON_DATE_SELECT: 'onDateSelect',
    FACEBOOK_LOGIN: 'onFacebookLogin',
    FACEBOOK_LOADED: 'onFacebookMarkersLoaded',
    USER_LOCATING: 'onUserLocating'
  };

  Map = (function() {
    Map.prototype.NEIGHBORS = 'neighbors';

    Map.prototype.COUNTRIES = 'countries';

    Map.prototype.projector = d3.geo;

    Map.prototype.color = d3.scale.category10();

    Map.prototype.renderer = null;

    Map.prototype.type = 'countries';

    Map.prototype.projectionType = null;

    Map.prototype.scale = null;

    Map.prototype.xOffset = null;

    Map.prototype.yOffset = null;

    Map.prototype.scaleMin = null;

    Map.prototype.scaleMax = null;

    Map.prototype.markerSize = null;

    Map.prototype.svg = null;

    Map.prototype.canvas = null;

    Map.prototype.group = null;

    Map.prototype.width = null;

    Map.prototype.height = null;

    Map.prototype.container = null;

    Map.prototype.projection = null;

    Map.prototype.countryStroke = 'rgba(72,66,53,0.5)';

    Map.prototype.pointColors = [Config.Graphics.Colors.location, Config.Graphics.Colors.grade['9'], Config.Graphics.Colors.grade['10'], Config.Graphics.Colors.grade['11'], Config.Graphics.Colors.grade['12'], Config.Graphics.Colors.faculty];

    Map.prototype.flickr = [];

    Map.prototype.students = [];

    Map.prototype.location = [];

    Map.prototype.facebook = [];

    Map.prototype.faculty = [];

    Map.prototype.tedxteen = [];

    Map.prototype.bgColor = 'rgba(242,236,223,0.4)';

    Map.prototype.data = null;

    Map.prototype.countries = null;

    Map.prototype.neighbors = null;

    Map.prototype.hasGrid = true;

    Map.prototype.arc = -100;

    Map.prototype.markerLocator = null;

    Map.prototype.startRotation = [0, -15];

    function Map(src, width, height, container, renderer, scale, projectionKey, hasGrid, startRotation) {
      this.src = src;
      this.width = width;
      this.height = height;
      this.container = container;
      this.renderer = renderer;
      this.scale = scale;
      this.projectionKey = projectionKey;
      this.hasGrid = hasGrid;
      this.startRotation = startRotation;
      this.onDataRead = __bind(this.onDataRead, this);
      this.update = __bind(this.update, this);
      this.createPath = __bind(this.createPath, this);
      this.createProjection = __bind(this.createProjection, this);
      this.updateCanvas = __bind(this.updateCanvas, this);
      this.updateSVG = __bind(this.updateSVG, this);
      this.zoomed = __bind(this.zoomed, this);
      this.onMouseDownHandler = __bind(this.onMouseDownHandler, this);
      this.onLocationReceived = __bind(this.onLocationReceived, this);
      this.onMouseWheel = __bind(this.onMouseWheel, this);
      this.fillNeighbors = __bind(this.fillNeighbors, this);
      this.onMarkerMouseOver = __bind(this.onMarkerMouseOver, this);
      this.trans = __bind(this.trans, this);
      this.onDateSelect = __bind(this.onDateSelect, this);
      this.onLocationMouseOver = __bind(this.onLocationMouseOver, this);
      this.createPoint = __bind(this.createPoint, this);
      this.onServerStarted = __bind(this.onServerStarted, this);
      this.onServerUpdated = __bind(this.onServerUpdated, this);
      this.onLocatingUser = __bind(this.onLocatingUser, this);
      this.projectionType = Config[Config.userType].Map.projections[this.projectionKey];
      this.loadFromConfig();
      this.markerLocator = $('#marker');
      if (this.renderer === 'canvas') {
        this.createCanvas();
      } else {
        this.createSVG();
      }
      this.readJSON();
    }

    Map.prototype.loadFromConfig = function() {
      this.xOffset = Config[Config.userType].Map.xOffset;
      this.yOffset = Config[Config.userType].Map.yOffset;
      this.scaleMin = Config[Config.userType].Map.scaleMin;
      this.scaleMax = Config[Config.userType].Map.scaleMax;
      return this.markerSize = Config[Config.userType].Map.markerSize;
    };

    Map.prototype.addListeners = function() {
      EventManager.addListener(Events.SERVER_UPDATED, this.onServerUpdated);
      EventManager.addListener(Events.SERVER_STARTED, this.onServerStarted);
      EventManager.addListener(Events.ON_DATE_SELECT, this.onDateSelect);
      return EventManager.addListener(Events.USER_LOCATING, this.onLocatingUser);
    };

    Map.prototype.createSVG = function() {
      this.svg = d3.select(this.container).append('svg').attr('id', 'svg-map').attr('width', this.width).attr('height', this.height).call(d3.behavior.zoom, this.zoom);
      console.log(Config['userType'] === 'user');
      return this.group = this.svg.append('g');
    };

    Map.prototype.onLocatingUser = function() {
      return this.group.on('mousedown', this.onMouseDownHandler);
    };

    Map.prototype.createCanvas = function() {
      this.canvas = d3.select(this.container).append('canvas').attr('width', this.width).attr('height', this.height).attr('id', 'marker-canvas').on('click', this.onMouseDownHandler);
      return this.context = this.canvas.node().getContext('2d');
    };

    Map.prototype.readJSON = function() {
      return d3.json(this.src, this.onDataRead);
    };

    Map.prototype.drawMap = function() {
      this.drawBackground();
      if (this.hasGrid) {
        this.drawGrid();
      }
      return this.drawCountries();
    };

    Map.prototype.drawGrid = function() {
      return;
      switch (this.renderer) {
        case 'svg':
          return this.group.append("path").datum(d3.geo.graticule()).attr("d", this.path).style("stroke", "#ffffff").style("stroke-width", "0.5px");
        case 'canvas':
          this.context.strokeStyle = 'white';
          this.context.beginPath();
          this.path(d3.geo.graticule()());
          return this.context.stroke();
      }
    };

    Map.prototype.onServerUpdated = function(event) {
      this.tedxteen.push(event);
      if (this.hasGrid) {
        this.drawGrid();
      }
      this.drawCountries();
      if (this.hasLines) {
        this.drawLines(this.lines);
      }
      this.createPoints('location', [], 'red');
      this.createPoints('students', [], 'blue');
      return this.createPoints('tedxteen', [], 'black');
    };

    Map.prototype.onServerStarted = function(event) {
      console.log(event);
      event = event || [];
      this.tedxteen = this.tedxteen.concat(event);
      if (this.hasGrid) {
        this.drawGrid();
      }
      this.drawCountries();
      this.createPoints('location', [], 'red');
      this.createPoints('students', [], 'blue');
      return this.createPoints('tedxteen', [], 'yellow');
    };

    Map.prototype.drawBackground = function() {
      var rgba, str;
      switch (this.renderer) {
        case 'svg':
          this.group.append("defs").append("path").datum({
            type: "Sphere"
          }).attr('id', 'sphere').attr("d", this.path).attr("stroke", this.countryStroke).attr("stroke-width", '1px').style("fill", this.bgColor);
          this.group.append("use").attr("class", "stroke").attr("xlink:href", "#sphere");
          return this.group.append("use").attr("class", "fill").attr("xlink:href", "#sphere");
        case 'canvas':
          rgba = [0, 40, 5, 1];
          str = 'rgba(' + rgba.join(',') + ')';
          this.context.fillStyle = str;
          return this.context.fillRect(0, 0, this.width, this.height);
      }
    };

    Map.prototype.drawCountries = function() {
      var error;
      switch (this.renderer) {
        case 'svg':
          try {
            return this.group.selectAll('.country').data(this.countries).enter().insert('path', '.graticule').attr('class', 'country').attr('d', this.path).style('fill', this.fillNeighbors).style('stroke', this.countryStroke);
          } catch (_error) {
            error = _error;
            return console.log(error);
          }
          break;
        case 'canvas':
          this.context.save();
          this.context.fillStyle = 'rgba( 255, 255, 255, 0.5 )';
          this.context.lineWidth = '0.2px';
          this.context.strokeStyle = 'rgba( 0, 0, 0, 0.7 )';
          this.context.beginPath();
          this.context.fill();
          this.path(this.countries);
          this.context.fill();
          this.path(this.neigbors);
          this.context.stroke();
          return this.context.restore();
      }
    };

    Map.prototype.createPoint = function(d) {
      var fn,
        _this = this;
      fn = function(el, idx, array) {
        var coords, size, _d, _i;
        _d = el.__data__.location.coords[0];
        _i = el.__data__['Grade'] - 8 || 0;
        coords = _this.projection([_d['longitude'], _d['latitude']]);
        size = 4 * (_i + 1);
        _this.context.fillStyle = _this.pointColors[_i];
        return _this.context.fillRect(coords[0], coords[1], size, size);
      };
      return d[0].forEach(fn);
    };

    Map.prototype.onLocationMouseOver = function(obj) {};

    Map.prototype.years = ['.y2014-y2015', '.y2013-y2014', '.y2012-y2013', '.y2011-y2012', '.y2010-y2012'];

    Map.prototype.onDateSelect = function(obj) {
      var year, _i, _len, _ref;
      console.log(obj);
      if (obj === "none") {

      } else {
        $('.faculty').css('opacity', 0);
        _ref = this.years;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          year = _ref[_i];
          if (year === obj) {
            console.log($(year));
            $(year).css('opacity', 1);
            return;
          } else {
            $(year).css('opacity', 0);
          }
        }
      }
    };

    Map.prototype.createPoints = function(name, data, color) {
      var g, l,
        _this = this;
      this.color = color;
      this[name] = this[name].concat(data);
      l = 0;
      switch (this.renderer) {
        case 'svg':
          g = this.group.selectAll('group').data(this[name]).enter().append('circle').attr('r', this.markerSize * 2).attr('fill', function(d) {
            var a, b, i, _i, _o;
            b = 0;
            a = _this.pointColors.length - 1;
            if (name === 'location') {
              _o = b;
            } else if (name === 'faculty') {
              _o = a;
            } else {
              i = 4;
            }
            if (d['Grade']) {
              _i = 2;
            } else {
              _i = _o;
            }
            return _this.pointColors[_i];
          }).attr('class', function(d) {
            var m, str, _p;
            if (d['Grade']) {
              str = 'student grade' + d['Grade'];
            } else {
              str = name;
            }
            if (d['year']) {
              m = d['month'];
              if (m > 8) {
                _p = parseInt(d['year'].split('20')[1]) + 1;
                str += ' y' + d['year'] + '-y20' + _p + ' m' + m;
              } else {
                _p = parseInt(d['year'].split('20')[1]) - 1;
                str += ' y20' + _p + '-y' + d['year'] + ' m' + m;
              }
              str += ' ' + d['type'] + '-location';
            }
            if (d['Year']) {
              str += ' y' + d['Year'];
              _p = parseInt(d['Year'].split('20')[1]) + 1;
              str += '-y20' + _p;
            }
            return str;
          }).attr('cx', function(d) {
            var coords, _d;
            _d = d.location.coords[0];
            coords = _this.projection([_d['longitude'], _d['latitude']]);
            return coords[0];
          }).attr('cy', function(d) {
            var coords, _d;
            _d = d.location.coords[0];
            coords = _this.projection([_d['longitude'], _d['latitude']]);
            return coords[1];
          }).on('mouseover', this.onMarkerMouseOver).style('opacity', 0).transition().delay(function(d) {
            var a, b, _gr, _o;
            l += l * 4;
            a = 3;
            b = 4;
            if (name === 'location') {
              _o = b;
            } else {
              _o = a;
            }
            _gr = d['Grade'] - 5 || _o;
            _gr *= 100;
            _gr += l * 10;
            return _gr;
          }).style('opacity', 1).attr('r', function(d) {
            var a, b, _o, _sca;
            d.isPulsed = true;
            a = 3;
            b = 4;
            if (name === 'location') {
              _o = b;
            } else {
              _o = a;
            }
            if (d['Grade']) {
              _sca = 5;
            } else {
              _sca = _o;
            }
            d.scale = _sca * 2;
            return d.scale;
          });
          if (name === 'student') {
            console.log(student);
            return g.on('mouseover', this.onLocationMouseOver);
          }
          break;
        case 'canvas':
          return this.canvas.select('canvas').data(this[name]).enter().call(this.createPoint);
      }
    };

    Map.prototype.trans = function(obj) {
      d3.select(obj).transition().attr('r', obj.isPulsed ? 0 : obj.scale).each('end', this.trans);
      if (obj.isPulsed === true) {
        return obj.isPulsed = false;
      } else {
        return obj.isPulsed = true;
      }
    };

    Map.prototype.drawLines = function(lines) {
      var coords, fn, path, _i, _len, _ref, _results,
        _this = this;
      this.lines = lines;
      _ref = this[this.lines[0]];
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        path = _ref[_i];
        coords = this.projection([path.location.coords[0]['longitude'], path.location.coords[0]['latitude']]);
        switch (this.renderer) {
          case 'svg':
            _results.push(this.group.selectAll('group').data(this[this.lines[1]]).enter().append('path').attr('d', function(d) {
              var l, m, _d;
              _d = d.location.coords[0];
              m = 'M' + coords.join(' ');
              l = 'L' + _this.projection([_d['longitude'], _d['latitude']]).join(' ');
              return [m, l].join(' ');
            }).attr('stroke', 'rgba(0,0,250,0.1)').attr('stroke-width', '1').attr('fill', 'none'));
            break;
          case 'canvas':
            fn = function(d) {
              var _f;
              _f = function(el, index, array) {
                var aCoords, cb, l1;
                aCoords = [el.__data__.location.coords[0].longitude, el.__data__.location.coords[0].latitude];
                l1 = _this.projection(aCoords);
                cb = function(d) {
                  var _g;
                  _g = function(el, index, array) {
                    var bCoords, colA, colB, dist, grad, l2, op, x1, y1;
                    bCoords = [el.__data__.location.coords[0].longitude, el.__data__.location.coords[0].latitude];
                    l2 = _this.projection(bCoords);
                    op = 0.05;
                    colA = [255, 255, 0, op];
                    colB = [255, 0, 0, op];
                    grad = _this.context.createLinearGradient(l1[0], l1[1], l2[0], l2[1]);
                    grad.addColorStop('0', 'rgba(' + colA.join(',') + ')');
                    grad.addColorStop('1', 'rgba(' + colB.join(',') + ')');
                    x1 = l2[0] - l1[0];
                    x1 = x1 * x1;
                    y1 = l2[1] - l1[1];
                    y1 = y1 * y1;
                    dist = Math.sqrt(x1 + y1);
                    dist /= 3;
                    _this.context.save();
                    _this.context.beginPath();
                    _this.context.lineWidth = '0.85';
                    _this.context.strokeStyle = grad;
                    _this.context.moveTo(l1[0], l1[1]);
                    _this.context.bezierCurveTo(l1[0] + dist, l1[1] - dist, l2[0] - dist, l2[1] - dist, l2[0], l2[1]);
                    _this.context.stroke();
                    return _this.context.restore();
                  };
                  return d[0].forEach(_g);
                };
                return _this.canvas.select('canvas').data(_this[_this.lines[1]]).enter().call(cb);
              };
              return d[0].forEach(_f);
            };
            _results.push(this.canvas.select('canvas').data(this[this.lines[0]]).enter().call(fn));
            break;
          default:
            _results.push(void 0);
        }
      }
      return _results;
    };

    Map.prototype.onMarkerMouseOver = function(d) {
      return EventManager.emitEvent(Events.MARKER_FOCUS, [d]);
    };

    Map.prototype.fillNeighbors = function(d, i) {
      var a, b, colorString, fn, g, r,
        _this = this;
      fn = function(n) {
        return _this.countries[n].color;
      };
      r = i - 50;
      b = i;
      g = i + 0;
      a = 0.6;
      colorString = 'rgba(' + [r, g, b, a].join(',') + ')';
      return 'rgba(225,225,255,0.8)';
    };

    Map.prototype.onMouseMove = function() {
      var m;
      return m = d3.mouse(this);
    };

    Map.prototype.onMouseWheel = function(e) {
      var m;
      return m = d3.event.wheelDeltaY;
    };

    Map.prototype.onLocationReceived = function(err, data) {
      var city, country, loc, obj, state;
      console.log(err, data);
      if (data[0] != null) {
        country = data[0].country;
        if (country === 'United States') {
          if (data[0].city != null) {
            city = data[0].city;
            city += ', ';
          }
        }
        state = data[0].state;
        loc = '';
        loc += country + ', ';
        if (city != null) {
          loc += city;
        }
        loc += state;
        obj = {
          location: loc,
          latitude: data[0].longitude,
          longitude: data[0].latitude
        };
        return EventManager.emitEvent(Events.MAP_CLICKED, [obj]);
      }
    };

    Map.prototype.onMouseDownHandler = function() {
      var coords, geo_loc, opts, str, _h, _m, _w, _x, _y;
      _m = d3.event;
      coords = [_m['offsetX'], _m['offsetY']];
      geo_loc = this.projection.invert(coords);
      str = '/location/' + geo_loc.join('/') + '/';
      console.log(str);
      d3.json(str, this.onLocationReceived);
      _h = this.markerLocator.height();
      _w = this.markerLocator.width();
      _x = coords[0] - (_h / 2);
      _y = coords[1] - (_w / 2);
      opts = {
        left: _x + 'px',
        top: _y + 'px',
        opacity: 1
      };
      this.markerLocator.css(opts);
      return this.group.on('mousedown', null);
    };

    Map.prototype.zoomed = function() {
      switch (this.renderer) {
        case 'svg':
          return this.updateSVG(d3.event.translate, d3.event.scale);
        case 'canvas':
          return this.updateCanvas(d3.event.translate, d3.event.scale);
      }
    };

    Map.prototype.updateSVG = function(pos, scale) {
      var l, tx, ty, _str;
      this.group.attr('transform', 'translate(' + pos.join(',') + ') scale(' + scale + ')');
      return;
      tx = Math.min(0, Math.max(this.width * (1 - scale), pos[0]));
      ty = Math.min(0, Math.max(this.height * (1 - scale), pos[1]));
      l = this.projection.translate([tx, ty]);
      _str = 'matrix(' + scale + ',0,0,' + scale + ',' + pos[0] + ',' + pos[1] + ')';
      return this.group.attr('transform', _str);
    };

    Map.prototype.updateCanvas = function(pos, scale) {
      var _str;
      _str = 'translate(' + pos.join(',') + ')scale(' + scale + ')';
      this.context.save();
      this.context.clearRect(0, 0, this.width, this.height);
      this.context.translate(pos[0], pos[1]);
      this.context.scale(scale[0], scale[1]);
      this.drawMap();
      return this.context.restore();
    };

    Map.prototype.createProjection = function() {
      return this.projection = this.projector[this.projectionType]().scale(this.scale).translate([(this.width / 2) - this.xOffset, (this.height / 2) - this.yOffset]).rotate(this.startRotation).precision(.25);
    };

    Map.prototype.createPath = function() {
      switch (this.renderer) {
        case 'canvas':
          return this.path = d3.geo.path().projection(this.projection).context(this.context);
        case 'svg':
          return this.path = d3.geo.path().projection(this.projection);
      }
    };

    Map.prototype.update = function() {
      return this.drawMap();
    };

    Map.prototype.onDataRead = function(error, world) {
      if (this.renderer === 'canvas') {
        this.countries = topojson.feature(world, world.objects[this.COUNTRIES]);
      } else {
        this.countries = topojson.feature(world, world.objects[this.COUNTRIES]).features;
      }
      this.neighbors = topojson.neighbors(world.objects[this.COUNTRIES].geometries);
      this.createProjection();
      this.createPath();
      this.drawMap();
      this.addListeners();
      if (this.renderer === 'svg') {
        this.group.call(d3.behavior.zoom().scaleExtent([1, 8]).on("zoom", this.zoomed));
      }
      return EventManager.emitEvent(Events.MAP_LOADED);
    };

    return Map;

  })();

  SocketClient = (function() {
    SocketClient.prototype.socket = null;

    function SocketClient(host, type) {
      this.host = host;
      this.type = type;
      this.onLocationsLoaded = __bind(this.onLocationsLoaded, this);
      this.onFacebookLoaded = __bind(this.onFacebookLoaded, this);
      this.onConnectionHandler = __bind(this.onConnectionHandler, this);
      this.onReceiveHandler = __bind(this.onReceiveHandler, this);
      this.onLocationHandler = __bind(this.onLocationHandler, this);
      this.onMapLoaded = __bind(this.onMapLoaded, this);
      this.connect = __bind(this.connect, this);
      this.createSocketConnection();
    }

    SocketClient.prototype.createSocketConnection = function() {
      var opts;
      opts = {
        port: Config.port
      };
      EventManager.addListener(Events.MAP_LOADED, this.onMapLoaded);
      this.socket = io.connect();
      return this.addListeners();
    };

    SocketClient.prototype.addListeners = function() {
      switch (Config.userType) {
        case 'user':
          this.socket.on('location', this.onLocationHandler);
          break;
        case 'facebook':
          this.socket.on('location', this.onLocationHandler);
      }
      this.socket.on('connection', this.onConnectionHandler);
      this.socket.on('connect', this.connect);
      this.socket.on('data', this.data);
      return this.socket.on('error', this.error);
    };

    SocketClient.prototype.connect = function(data) {
      return EventManager.emitEvent(Events.SOCKET_CONNECTED);
    };

    SocketClient.prototype.data = function(data) {};

    SocketClient.prototype.error = function(error) {};

    SocketClient.prototype.onMapLoaded = function(event) {
      console.log('map loaded');
      switch (Config.userType) {
        case 'display':
          this.socket.on('receiveResponse', this.onReceiveHandler);
          this.socket.on('locationsLoaded', this.onLocationsLoaded);
          this.socket.on('facebookLoaded', this.onFacebookLoaded);
          return this.socket.emit('serverStarted');
      }
    };

    SocketClient.prototype.onLocationHandler = function(data) {
      var cb,
        _this = this;
      console.log('location');
      cb = function(data) {
        var opts;
        console.log('map clicked');
        opts = {
          location: {
            title: data.location,
            coords: [
              {
                latitude: data.longitude,
                longitude: data.latitude
              }
            ]
          }
        };
        return _this.socket.emit('gps', opts);
      };
      return EventManager.addListener(Events.MAP_CLICKED, cb);
    };

    SocketClient.prototype.onReceiveHandler = function(data) {
      return EventManager.emitEvent(Events.SERVER_UPDATED, [data]);
    };

    SocketClient.prototype.onConnectionHandler = function(socket) {
      return null;
    };

    SocketClient.prototype.onFacebookLoaded = function(data) {
      var obj;
      console.log('fb loaded');
      obj = JSON.parse(JSON.parse(data));
      return EventManager.emitEvent(Events.FACEBOOK_LOADED, [obj]);
    };

    SocketClient.prototype.onLocationsLoaded = function(data) {
      var loc, obj, objects, _locs;
      console.log('locations loaded');
      obj = JSON.parse(JSON.parse(data));
      objects = [];
      if (obj != null) {
        for (loc in obj.locations) {
          _locs = JSON.parse(obj.locations[loc]);
          objects.push(_locs);
        }
        return EventManager.emitEvent(Events.SERVER_STARTED, [objects]);
      }
    };

    return SocketClient;

  })();

  TGS = (function() {
    TGS.prototype.flickrSrc = Config.TGS.src;

    TGS.prototype.studentsSrc = Config.TGS.students_src;

    TGS.prototype.facultySRC = Config.TGS.faculty_src;

    TGS.prototype.JSON_PATH = null;

    TGS.prototype.speed = 1e-2;

    TGS.prototype.mapHeight = null;

    TGS.prototype.mapWidth = null;

    TGS.prototype.velocity = null;

    TGS.prototype.scale = null;

    TGS.prototype.projectionKey = null;

    TGS.prototype.rotation = null;

    TGS.prototype.hasRotation = null;

    TGS.prototype.hasLines = null;

    TGS.prototype.hasGrid = null;

    TGS.prototype.origin = 0;

    TGS.prototype.start = null;

    TGS.prototype.map = null;

    TGS.prototype.bookingInformation = null;

    TGS.prototype.renderer = null;

    TGS.prototype.mapContainer = null;

    TGS.prototype.svg = null;

    TGS.prototype.container = null;

    TGS.prototype.loader = null;

    TGS.prototype.classes = ['student', 'faculty', 'past-location', 'current-location', 'future-location', 'tedxteen', 'facebook'];

    function TGS() {
      this.onMarkerFocused = __bind(this.onMarkerFocused, this);
      this.onBookingLoaded = __bind(this.onBookingLoaded, this);
      this.onMapLoaded = __bind(this.onMapLoaded, this);
      this.onFacebookLogin = __bind(this.onFacebookLogin, this);
      this.onFacebookMarkersLoaded = __bind(this.onFacebookMarkersLoaded, this);
      this.addUserLocator = __bind(this.addUserLocator, this);
      this.onSocketConnected = __bind(this.onSocketConnected, this);
      this.loop = __bind(this.loop, this);
      this.changeTitle = __bind(this.changeTitle, this);
      var url;
      this.loadFromConfig();
      url = 'http://' + window.location.hostname + '/';
      this.mapHeight = this.mapHeight || $(window).height();
      this.mapWidth = this.mapWidth || $(window).width();
      this.loader = $('#loader-container');
      this.start = Date.now();
      this.title = $('#location-title');
      this.redisData = [];
      $(this.mapContainer).css({
        width: this.mapWidth,
        height: this.mapHeight
      });
      this.addListeners();
      this.socket = new SocketClient(url, Config.userType);
    }

    TGS.prototype.changeTitle = function(event) {
      var el, l;
      if (typeof event.location === "string") {
        l = event.location;
      } else {
        l = event.location.title;
      }
      if (Config.userType === 'user') {
        el = $('#marker-icon');
        el.removeClass('active');
        el.addClass('inactive');
      }
      this.title.css({
        'opacity': 1
      });
      return this.title.html('<p>' + l + '</p>');
    };

    TGS.prototype.loadFromConfig = function() {
      this.mapHeight = Config[Config.userType].Map.height;
      this.mapWidth = Config[Config.userType].Map.width;
      this.velocity = Config[Config.userType].Map.velocity / 1000;
      this.scale = Config[Config.userType].Map.scale;
      this.projectionKey = Config[Config.userType].Map.projectionKey;
      this.rotation = Config[Config.userType].Map.rotation;
      this.renderer = Config[Config.userType].Settings.renderer;
      this.hasRotation = Config[Config.userType].Settings.hasRotation;
      this.hasLines = Config[Config.userType].Settings.hasLines;
      this.hasGrid = Config[Config.userType].Settings.hasGrid;
      this.renderer = Config[Config.userType].Settings.renderer;
      this.mapContainer = Config[Config.userType].Map.container;
      return this.JSON_PATH = Config[Config.userType].Settings.jsonPath;
    };

    TGS.prototype.startRotation = function() {
      var framerate,
        _this = this;
      framerate = 1000 / 60;
      return setInterval((function() {
        return _this.loop();
      }), framerate);
    };

    TGS.prototype.loop = function() {
      if (this.renderer === 'canvas') {
        this.map.context.clearRect(0, 0, this.mapWidth, this.mapHeight);
      }
      this.map.projection = this.map.projection.rotate([this.origin + this.velocity * (Date.now() - this.start), -15]);
      this.map.drawMap();
      if (this.hasLines) {
        return this.map.drawLines(['students', 'location']);
      }
    };

    TGS.prototype.onTGSFlickrDataLoaded = function(flickrData) {
      this.flickrData = flickrData;
      this.map.createPoints('location', this.flickrData, 'red');
      return d3.json(this.studentsSrc, _.bind(this.onTGSStudentsDataLoaded, this));
    };

    TGS.prototype.onTGSFacultyLoaded = function(facultyData) {
      this.facultyData = facultyData;
      return this.map.createPoints('faculty', this.facultyData, 'red');
    };

    TGS.prototype.onTGSStudentsDataLoaded = function(studentData) {
      this.studentData = studentData;
      this.map.createPoints('students', this.studentData, 'blue');
      if (this.hasLines) {
        this.map.drawLines(['students', 'location']);
      }
      if (this.renderer === 'canvas' && this.hasRotation) {
        return this.startRotation();
      }
    };

    TGS.prototype.createBookingData = function() {
      return this.booking = new Booking(this.CSV_PATH);
    };

    TGS.prototype.onSocketConnected = function() {
      console.log('socket connected');
      this.createMap();
      return this.addPanelHover();
    };

    TGS.prototype.addPanelHover = function() {
      var fn, panel,
        _this = this;
      panel = $('.marker-type li');
      fn = function(event) {
        var e, l, s, ts, _v;
        s = event.currentTarget.id;
        l = $('.' + s);
        e = $('#' + s);
        ts = 300;
        _v = function(el, idx, arr) {
          var _m, _u;
          _m = function(d) {
            _.each(_this.classes, function(el, idx, arr) {
              return $('.' + el).css('opacity', 1);
            });
            e.off('mouseleave');
            panel.on('mouseover', fn);
            return d3.selectAll('.' + el).transition().delay(function() {
              var del;
              del = Math.random() * ts;
              return del;
            }).attr('r', function(d) {
              return d.scale;
            }).style('z-index', 10);
          };
          if (el === s) {
            e.mouseleave(_m);
            panel.off('mouseover');
            d3.selectAll('.' + el).transition().delay(function() {
              var del;
              del = Math.random() * ts;
              return del;
            }).attr('r', function(d) {
              return d.scale * ((Math.random() * 3) + 2);
            }).style('z-index', 10000);
            _u = 1;
          } else {
            _u = 0.3;
          }
          return $('.' + el).css('opacity', _u);
        };
        return _.each(_this.classes, _v);
      };
      return panel.on('mouseover', fn);
    };

    TGS.prototype.addListeners = function() {
      EventManager.addListener(Events.MAP_LOADED, this.onMapLoaded);
      EventManager.addListener(Events.SERVER_UPDATED, this.changeTitle);
      EventManager.addListener(Events.MAP_CLICKED, this.changeTitle);
      EventManager.addListener(Events.SOCKET_CONNECTED, this.onSocketConnected);
      EventManager.addListener(Events.FACEBOOK_LOGIN, this.onFacebookLogin);
      EventManager.addListener(Events.FACEBOOK_LOADED, this.onFacebookMarkersLoaded);
      if (Config.userType === 'user') {
        return this.addUserLocator();
      }
    };

    TGS.prototype.isSelectingLocation = false;

    TGS.prototype.addUserLocator = function() {
      var f, userElement,
        _this = this;
      console.log('adding user locator');
      f = function(event) {
        var a;
        _this.isSelectingLocation = true;
        a = $(event.currentTarget);
        a.addClass('active');
        a.removeClass('inactive');
        return EventManager.emitEvent(Events.USER_LOCATING, [event]);
      };
      userElement = $('#marker-icon');
      return userElement.on('click', f);
    };

    TGS.prototype.onFacebookMarkersLoaded = function(event) {
      console.log(event);
      this.map.createPoints('facebook', event.locations, 'blue');
      return null;
    };

    TGS.prototype.onFacebookLogin = function(event) {
      var fn, id, src, uid,
        _this = this;
      console.log('facebook loaded');
      console.log(event);
      id = event.location.id;
      src = Config.FACEBOOK.location;
      uid = Math.random().toString(36).substr(2, 9);
      fn = function(d) {
        var key;
        key = {
          id: event.id || uid(),
          location: {
            coords: [d.location],
            name: d.name
          }
        };
        return _this.socket.socket.emit('facebook', key);
      };
      return d3.json(src + id, fn);
    };

    TGS.prototype.onMapLoaded = function() {
      this.loader.remove();
      d3.json(this.flickrSrc, _.bind(this.onTGSFlickrDataLoaded, this));
      return d3.json(this.facultySRC, _.bind(this.onTGSFacultyLoaded, this));
    };

    TGS.prototype.onBookingLoaded = function(event) {
      this.map.createPoints(this.booking.data);
      this.bookingInformation = new BookingInformation();
      return EventManager.addListener(Events.MARKER_FOCUS, this.onMarkerFocused);
    };

    TGS.prototype.onMarkerFocused = function(event) {
      this.bookingInformation.changeTourTitle(event.booking_id);
      this.bookingInformation.changeTourCityTitle(event.tour_address);
      return this.bookingInformation.changeBookerCityTitle(event.booker_country);
    };

    TGS.prototype.createMap = function() {
      this.map = new Map(this.JSON_PATH, this.mapWidth, this.mapHeight, this.mapContainer, this.renderer, this.scale, this.projectionKey, this.hasGrid, this.rotation);
      if (this.hasGrid) {
        return this.map.hasGrid = true;
      }
    };

    return TGS;

  })();

  $(document).ready((function() {
    return new TGS();
  }));

}).call(this);
