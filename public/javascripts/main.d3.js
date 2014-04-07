// Generated by CoffeeScript 1.6.3
(function() {
  var CANVAS, EventManager, Events, NodeViewer, ParticleImages, PhysicsDemo, RGB, TypePath, Voronoi, btw, init, mf, mmax, mmin, mr,
    _this = this,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  ParticleImages = [
    {
      name: "hello-world",
      offset: {
        x: 420,
        y: 140
      },
      paths: ["M121.29,20.196c-1.983,6.5-11.653,26.617-25.599,46.698c12.576-11.527,23.856-16.951,30.822-16.812" + "c10.272,0.228,12.043,9.014,6.382,21.092c-2.775,6.426-23.963,36.006-28.608,45.02c-2.279,4.559-3.275,8.869-0.516,12.531" + "c-7.738,10.369-17.629,14.954-24.517,14.074c-7.392-0.912-11.056-7.675-5.158-18.292c7.163-12.853,26.049-35.625,32.667-48.505" + "c3.212-6.113,3.708-10.038,0.372-10.112c-4.457-0.087-17.308,11.065-27.742,24.082c-0.455,0.596-0.911,1.192-1.369,1.788" + "c-6.59,9.322-16.058,21.604-21.971,31.485c-2.337,3.914-4.122,7.522-5.668,10.788c-3.812,1.174-10.374,2.134-15.613,1.414" + "c-6.548-0.906-11.136-4.072-6.081-11.557c3.145-5.382,21.677-26.163,37.423-47.432C82.264,55.211,95.628,33.476,97.76,26.69" + "c1.566-3.876,1.727-7.799-1.055-8.411c3.886-8.143,11.202-14.573,19.052-14.27C123.866,4.322,124.148,11.806,121.29,20.196z", "M176.845,132.499c-3.761,11.24-20.303,18.368-34.257,16.987c-16.652-1.466-29.874-14.441-17.693-39.857" + "c15.69-31.74,43.424-58.942,67.4-58.441c10.101,0.305,16.992,7.572,12.143,21.84c-7.69,22.735-29.05,36.47-49.147,35.372" + "c-1.707-0.074-3.173-0.346-4.483-0.61c-6.456,15.249-2.88,21.178,4.02,21.55c4.452,0.314,10.061-1.501,18.496-10.978" + "C176.604,121.559,178.712,127.019,176.845,132.499z M180.319,74.694c1.699-4.422,0.592-7.707-1.867-7.765" + "c-4.355-0.016-12.687,9.626-21.673,28.18c0.678,0.22,1.439,0.247,2.2,0.272C167.544,95.671,176.462,84.788,180.319,74.694z", "M257.625,24.953c-0.997,6.342-7.52,24.569-15.929,45.885c-8.133,20.825-18.151,44.74-19.764,51.119" + "c-1.483,5.157-1.77,10.086,1.187,14.081c-4.022,7.724-11.865,18.696-21.045,18.112c-12.778-0.917-10.88-13.254-7.804-22.801" + "c3.098-10.406,14.052-34.401,23.022-55.041c9.22-21.034,16.456-38.71,17.871-45.591c0.867-3.637,0.412-7.293-2.47-7.906" + "c2.615-7.537,9.316-13.317,17.22-12.918C258.08,10.313,259.144,17.178,257.625,24.953z", "M294.569,26.472c-0.789,6.251-6.325,23.946-13.456,45.223c-6.898,20.719-15.391,45.02-16.705,51.586" + "c-1.192,5.267-1.213,10.309,1.941,14.344c-3.597,7.936-10.872,19.37-20.043,18.979c-12.764-0.663-11.476-13.496-8.933-23.356" + "c2.583-10.815,12.009-35.397,19.717-56.062c7.925-21.129,14.13-38.34,15.277-45.134c0.694-3.564,0.083-7.143-2.823-7.752" + "c2.296-7.367,8.828-12.983,16.746-12.568C294.475,12.173,295.751,18.872,294.569,26.472z", "M282.872,109.402c7.739-34.674,27.515-54.733,49.616-54.403c17.437,0.733,26.901,12.037,24.352,34.93" + "c-3.24,30.505-26.04,68.973-51.85,68.604C284.913,158.184,277.283,134.905,282.872,109.402z M308.305,106.61" + "c-2.662,14.813-1.656,28.757,4.728,28.834c7.847-0.015,15.975-22.874,18.608-40.702c2.128-14.348,0.675-24.213-5.233-24.391" + "C319.392,70.214,311.868,86.929,308.305,106.61z", "M358.396,144.996c1.22-12.306,8.492-22.462,17.318-22.48c7.909,0.021,10.901,8.647,10.11,21.282" + "c-1.228,21.257-15.764,60.391-32.537,61.005c-5.288,0.018-6.39-4.943-5.878-10.613c0.254-2.838,0.846-5.63,1.598-8.377" + "c0.223,0,0.446,0,0.669,0c6.226-0.04,13.036-12.251,13.794-21.635c0.417-5.022-0.821-9.542-4.871-11.117" + "C358.199,150.409,358.151,147.548,358.396,144.996z", "M433.17,61.917c3.163-2.486,8.55-4.054,13.521-3.931c9.505,0.267,12.361,4.827,12.618,12.64" + "c0.372,10.362-3.942,26.539-3.621,44.645c0.102,4.863,0.505,9.71,1.55,14.488c12.142-6.162,16.956-39.51,16.091-53.865" + "c-0.259-4.996-1.116-10.22-2.848-13.498c2.606-2.27,7.069-3.668,11.621-3.563c6.11,0.176,12.313,3.04,12.966,10.367" + "c0.523,6.118-0.678,15.331-3.74,26.592c1.359,18.237,2.714,26.886,4.865,32.605c11.878-6.129,14.989-38.328,13.343-52.234" + "c-0.524-4.836-1.655-9.897-3.556-13.076c2.491-2.206,6.884-3.567,11.442-3.471c6.122,0.163,12.472,2.933,13.514,10.013" + "c1.226,9.239-1.015,26.21-8.178,45.271c-7.081,18.403-19.083,38.895-35.471,39.976c-2.592,0.156-4.729-0.236-7.224-1.632" + "c-3.605-4.402-5.132-10.582-5.891-17.344c-7.274,11.537-16.532,20.613-27.096,21.035c-2.596,0.111-4.71-0.335-7.138-1.818" + "c-6.147-8.463-7.725-20.675-7.608-32.249c0.229-20.627,3.448-25.999,3.512-45.829C435.861,71.341,434.718,65.615,433.17,61.917z", "M540.553,107.835c-4.2-30.509,8.77-47.375,31.103-47.17c17.649,0.532,30.828,9.834,36.056,28.077" + "c7.257,23.981-4.204,55.667-29.808,58.903C558.046,149.922,543.671,130.372,540.553,107.835z M564.868,104.232" + "c2.32,12.551,7.673,24.123,14.012,23.617c7.8-0.75,8.707-19.784,5.262-34.383c-2.725-11.778-7.532-19.901-13.488-19.978" + "C563.556,73.443,561.804,87.557,564.868,104.232z", "M653.533,124.689c0.919,2.871,2.223,5.967,3.422,8.752c-3.198,2.544-9.134,4.54-12.676,4.981" + "c-9.35,1.194-13.668-4.01-15.155-9.565c-1.271-5.934-6.119-43.219-8.272-49.299c-1.071-3.439-3.182-6.472-6.739-7.167" + "c-0.876-5.454,2.455-11.178,11.46-11.038c8.443,0.136,13.3,4.329,15.646,10.848c0.572,1.605,0.812,2.677,1.203,5.003" + "c1.996-11.335,8.177-15.368,13.753-15.376c5.307,0.06,8.498,3.025,10.021,6.682c1.62,3.896,1.114,8.594-1.159,11.075" + "c-4.249-2.338-8.284-3.223-10.495-3.199c-8.962,0.002-9.301,11.744-8.59,20.077C649.479,111.049,650.913,116.594,653.533,124.689z", "M689.45,42.696c1.897,7.432,17.662,55.696,22.118,65.472c1.615,3.293,4.199,6.3,9.317,8.167" + "c0.504,5.016-1.108,12.714-10.138,14.225c-12.576,2.017-17.633-6.267-20.385-12.938c-6.263-16.428-18.123-62.747-20.649-70.896" + "c-0.968-2.593-3.109-5.219-6.278-5.68c-0.834-5.408,3.86-9.527,11.934-9.175C683.724,32.239,687.291,37.183,689.45,42.696z", "M744.228,48.709c-1.97-3.673-4.658-5.038-7.055-5.425c-1.619-5.125,3.332-8.881,10.882-8.608" + "c6.65,0.224,11.557,2.993,15.271,9.886c1.919,7.17,26.229,49.33,31.254,54.732c2.097,2.484,4.608,4.263,10.067,5.381" + "c1.935,6.101-2.534,9.656-9.428,11.016c-9.152,1.853-16.389-1.4-21.277-8.408c-0.581-0.824-1.244-1.763-1.667-2.6" + "c0.263,9.446-5.758,16.399-14.762,18.03c-11.575,2.332-24.77-5.376-33.471-21.592c-12.368-22.89-7.418-38.904,10.034-38.868" + "c5.351,0.002,10.836,1.778,18.755,5.272C749.896,60.95,744.626,49.699,744.228,48.709z M756.913,75.879" + "c-5.769-3.044-9.777-3.763-12.293-3.711c-6.718,0.124-7.48,8.872,1.354,22.808c4.849,7.618,11.459,14.955,16.526,14.242" + "c3.65-0.508,6.274-6.617,4.174-14.446C763.308,88.288,760.01,82.032,756.913,75.879z"]
    }, {
      name: "face",
      offset: {
        x: 300,
        y: 470
      },
      paths: ["M307.082,744.359c0,0-157.627,49.507-265.748-71.132" + "c0,0,69.993-5.122,80.805-22.193l13.657-149.66c0,0-31.298,5.122-29.021-14.796c2.276-19.917,6.26-14.226,6.26-14.226" + "s11.382,24.469,23.9,17.64c0,0-6.829-12.521,5.122-12.52c11.95,0.001,45.524,4.553,59.181-21.055s21.056-61.458,15.934-93.894" + "s-33.005-37.558-33.005-37.558s26.746,12.519,22.762,56.336c-3.983,43.817-21.625,68.856-34.712,79.668s-32.436,13.089-52.922-3.414" + "c-20.486-16.503-50.078-55.768-59.182-95.601C51.007,322.121,6.051,146.852,181.889,63.771" + "c175.839-83.082,286.236,47.801,286.236,47.801s3.374,125.993-72.878,157.291c-76.253,31.298-97.308,15.935-129.745,45.525" + "c0,0-11.381,40.972,8.536,52.353c0,0-34.712-15.365-21.624-60.32c0,0,13.657,19.917,52.922-3.983s57.478,17.641,17.642,20.486" + "c-39.835,2.845-61.459-13.088-57.476,10.243c0,0,13.089-7.967,25.039-7.398s23.899,10.812,31.297,10.243" + "c7.399-0.569-14.226,5.122-29.59,10.812c-15.365,5.69-25.608-5.122-25.608-5.122s7.397,3.415,13.088,2.845" + "c0,0-6.26-12.52,2.845-15.364c9.105-2.845,25.038-3.983,15.365,12.519c-9.674,16.502-11.382-13.088-6.829-10.812", "M143.764,491.698c0,0-21.623,110.966,87.065,165.595" + "c108.688,54.629,132.02,38.696,138.849,35.282c6.829-3.415,3.414-6.829,3.414-6.829s27.316,14.228,62.597-21.623" + "s36.419-53.49,48.369-75.684s22.193-31.297,35.85-81.943c13.658-50.646,40.404-153.645,30.729-202.015" + "c0,0,7.399,52.353,2.846,62.596c0,0,54.061-68.855,35.85-130.882c-18.21-62.027-59.184-97.309-123.486-106.414" + "c0,0,28.455,5.121,29.592,10.812c1.137,5.691,15.932,76.254,7.966,95.033s-34.143,31.297-34.143,31.297s14.797,1.139,14.227,9.674" + "c-0.57,8.536,6.829,19.347,6.829,19.347s25.604-2.277,37.556,9.674c11.952,11.951,14.228,26.746,14.228,26.746l-5.69,9.674" + "c0,0,12.52,0.569,1.707,12.52c-10.813,11.95-10.813,11.95-10.813,11.95s-1.706-16.503-13.087-17.641" + "c-11.381-1.138-33.006-2.276-38.127,9.674c0,0,34.711-43.249,51.215-1.139l-14.794,1.707c0,0,2.276-13.087-9.674-10.242" + "c-11.95,2.845-7.967,16.502-1.708,17.64c6.26,1.138,8.536-5.69,8.536-5.69s11.952-15.934-9.104-15.365s-26.746,19.917-26.746,19.917" + "l10.812,121.208l-90.479,35.851", "M377.646,485.438c0,0-6.262,9.106-3.984,18.211" + "c0,0,25.609-13.657,34.713-3.415c9.104,10.243,6.258,38.695,6.258,38.695l-13.657,2.846c0,0,0.568,20.484,6.829,24.469" + "s-6.26,18.778-10.243,29.021s-6.827,18.209-19.916,20.486s-49.508-11.38-50.646-35.28c0,0,11.382,12.521,21.625,22.193" + "c10.243,9.672,25.038,0,25.038,0l-0.569,24.469l-3.414-25.607c0,0-9.104,21.624-44.955-20.486c0,0-2.277,1.707-9.106-1.707" + "c0,0,47.232-22.193,52.354-30.729c0,0-1.137,9.106,14.796,9.675c15.933,0.568,11.95-9.104,25.607-6.828" + "c13.657,2.275,13.088,11.38,13.657,17.64c0.568,6.26-2.276,10.241-8.536,10.812c-6.26,0.57-8.536-5.12-15.364-4.552" + "c-6.829,0.569-5.122,3.981-11.382,2.845c-6.26-1.137,0.002-7.966-10.811-7.966c-10.813,0-27.883,10.243-44.387,10.243", "M436.826,659.57c0,0,22.193,0,49.507,27.314c27.315,27.314,54.062,37.556,67.15,42.109C566.57,733.547,612.095,762,612.095,762"]
    }, {
      name: "bike",
      offset: {
        x: 320,
        y: 300
      },
      paths: ["M527.997,129.052c-22.906,0-46.48,6.156-65.97,17.987L420.673,95.81        l6.671-18.011c24.688-3.826,30.381-10.242,36.898-17.369c6.515-7.128,5.519-12.023-4.215-11.98        c-9.735,0.042-60.978,2.931-95.469,4.398c-6.591,0.215-11.658,4.835-5.871,9.862c5.785,5.027,30.011,13.679,44.057,15.507        l-2.67,8.156H225.317l12.582-44.596l-10.006-18.01l8.672-9.339h42.691l-0.667-14.009h-48.695l-22.681,24.682l11.341,19.344        l-35.788,98.732c-17.311-9.254-37.781-14.127-57.763-14.127c-68.719,0-124.766,56.046-124.766,124.765        c0,68.72,56.047,124.771,124.766,124.771c68.719,0,124.766-56.047,124.766-124.766c0-38.016-18.032-74.568-48.16-98.3l5.559-15.062        l124.131,140.39c-3.66,10.444,2.781,20.967,15.072,22.979l8.264,32.126h-6.672v9.339l27.35-1.334l-0.666-8.672h-8.672        l-6.779-32.146c4.529-2.688,8.322-6.123,9.949-10.603l37.996-6.828c14.611,53.885,64.322,92.874,120.856,92.874        c68.72,0,124.767-56.047,124.767-124.766C652.764,185.099,596.717,129.052,527.997,129.052z M226.03,253.814        c0,55.645-45.383,101.026-101.026,101.026S23.977,309.459,23.977,253.814c0-55.644,45.383-101.025,101.026-101.025        c17.759,0,35.912,5.13,50.55,13.771c-9.908,31.311-19.547,47.458-50.033,71.999c-7.4,0.313-13.028,6.254-13.028,13.342        c0,7.349,5.993,13.342,13.341,13.342c7.348-0.001,12.799-5.994,12.799-13.676c23.425-18.604,41.658-36.34,54.806-71.825        C214.191,198.566,226.03,225.797,226.03,253.814z M346.629,248.564l-2-14.676h5.336l-0.667-9.339H325.95l0.666,8.673h6.004        l1.334,16.01c0,0-117.401-132.125-118.069-132.792l2.716-8.314l174.429-0.229L346.629,248.564z M403.855,265.133l-39.664,4.021        l48.973-149.399l31.642,37.883c-30.382,27.949-41.575,61.575-41.575,96.178C403.23,257.229,403.717,262.102,403.855,265.133z         M458.938,176.147l53.834,69.928l-85.418,13.942C427.562,229.684,431.033,200.477,458.938,176.147z M527.996,354.843        c-44.988,0-85.636-30.782-97.063-73.362l91.829-17.608c1.805,0.849,3.94,1.37,5.974,1.37c7.348,0,13.342-5.993,13.342-13.342        c0-7.243-5.838-13.237-12.545-13.342l-54.834-72.804c14.99-8.777,35.539-12.967,53.298-12.967        c55.644,0,101.028,45.383,101.028,101.026C629.024,309.459,583.641,354.843,527.996,354.843z"]
    }
  ];

  TypePath = (function() {
    TypePath.prototype.STEP_SIZE = 14;

    TypePath.prototype.images = ParticleImages;

    TypePath.prototype.ctx = null;

    TypePath.prototype.lines = [];

    TypePath.prototype.imagesData = [];

    TypePath.prototype.paths = [];

    function TypePath() {
      var group, image, path, _i, _image, _j, _len, _len1, _path, _ref, _ref1;
      this.svg = new SVG('svgElement');
      _ref = this.images;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        image = _ref[_i];
        group = this.svg.group();
        _image = {
          paths: [],
          name: image.name,
          points: [],
          offset: image.offset
        };
        _ref1 = image.paths;
        for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
          path = _ref1[_j];
          _path = group.path();
          _path.attr('d', path);
          _image.paths.push(_path);
        }
        this.imagesData.push(_image);
      }
      this.getPoints();
    }

    TypePath.prototype.getPoints = function() {
      var imageData, line, path, pathData, point, totalLength, _i, _j, _len, _len1, _ref, _ref1, _results;
      _ref = this.imagesData;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        imageData = _ref[_i];
        pathData = [];
        _ref1 = imageData.paths;
        for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
          line = _ref1[_j];
          path = {};
          totalLength = path.totalLength = ~~line.node.getTotalLength();
          while (totalLength > 0) {
            point = line.node.getPointAtLength(totalLength);
            pathData.push([point.x, point.y]);
            totalLength -= this.STEP_SIZE;
          }
          path.pathData = pathData;
          imageData.points.push(path);
        }
        _results.push(this.paths.push(imageData));
      }
      return _results;
    };

    TypePath.prototype.getPaths = function() {
      return this.paths;
    };

    return TypePath;

  })();

  EventManager = new EventEmitter();

  Events = {
    CLOSE_EVENT: "Close Event",
    SLIDE_EVENT_CLICK: "On Slide Click",
    WINDOW_RESIZE: "On Window Resize",
    KEYBOARD_EVENT: "On Key Press",
    BUTTON_GO_EVENT: "On Button Go",
    VIDEO_CLOSE: "On Video Close"
  };

  (function() {
    var MIN_HEIGHT, MIN_WIDTH;
    MIN_WIDTH = 1024;
    MIN_HEIGHT = 768;
    window.onkeydown = function(event) {
      return EventManager.emitEvent(Events.KEYBOARD_EVENT, [event]);
    };
    window.onresize = function(e) {
      return EventManager.emitEvent(Events.WINDOW_RESIZE, [e]);
    };
    return $(window).on('hashchange', function(e) {
      return EventManager.emitEvent(Events.URL_CHANGE, [e]);
    });
  })();

  PhysicsDemo = (function() {
    PhysicsDemo.prototype.AVOID_MOUSE_STRENGTH = 25000;

    PhysicsDemo.prototype.SPEED = 2;

    PhysicsDemo.prototype.MIN_SPEED = 1.3;

    PhysicsDemo.prototype.X_OFFSET = 300;

    PhysicsDemo.prototype.Y_OFFSET = 470;

    PhysicsDemo.prototype.DESTROY_SIZE = 0.45;

    PhysicsDemo.prototype.engine = null;

    PhysicsDemo.prototype.sketch = null;

    PhysicsDemo.prototype.min_mass = 2;

    PhysicsDemo.prototype.max_mass = 25;

    PhysicsDemo.prototype.destroy = false;

    PhysicsDemo.prototype.renderer = null;

    PhysicsDemo.prototype.isDrawingParticles = true;

    PhysicsDemo.prototype.isPhysicsRunning = true;

    PhysicsDemo.prototype.counter = 0;

    PhysicsDemo.prototype.max_count = 205;

    PhysicsDemo.prototype.fills = ['rgba(0,100,100, 1)', 'rgba(10,100,100, 1)', 'rgba(120,120,20, 1)', 'rgba(130,130,130, 1 )', 'rgba(100,100,100, 1)'];

    PhysicsDemo.prototype.timeline = null;

    PhysicsDemo.prototype.currentIndex = 0;

    function PhysicsDemo(pathImages) {
      this.pathImages = pathImages;
      this.onmousemove = __bind(this.onmousemove, this);
      this.draw = __bind(this.draw, this);
      this.redistributeParticles = __bind(this.redistributeParticles, this);
      this.onresize = __bind(this.onresize, this);
      this.onTimelineComplete = __bind(this.onTimelineComplete, this);
      this.avoidMouse = new Attraction();
      this.createSketch();
      this.max_index = this.pathImages.length;
    }

    PhysicsDemo.prototype.changeImage = function(index) {
      this.currentIndex = index;
      this.X_OFFSET = this.pathImages[this.currentIndex].offset.x;
      this.Y_OFFSET = this.pathImages[this.currentIndex].offset.y;
      return this.createParticles(this.pathImages[this.currentIndex].points);
    };

    PhysicsDemo.prototype.setupGUI = function() {
      return this.gui.add(this, 'AVOID_MOUSE_STRENGTH', 5000, 15000);
    };

    PhysicsDemo.prototype.onTimelineComplete = function() {
      return this.isPhysicsRunning = true;
    };

    PhysicsDemo.prototype.onresize = function() {
      this.sketch.height = window.innerHeight;
      this.sketch.width = window.innerWidth;
      return this.redistributeParticles();
    };

    PhysicsDemo.prototype.redistributeParticles = function() {
      var particle, target, _i, _len, _ref, _results;
      _ref = this.engine.particles;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        particle = _ref[_i];
        target = particle.behaviours[1].target;
        target.x = particle.destX + ((this.sketch.width / 2) - this.X_OFFSET);
        target.y = particle.destY + ((this.sketch.height / 2) - this.Y_OFFSET);
        _results.push(particle.moveTo(target));
      }
      return _results;
    };

    PhysicsDemo.prototype.createSketch = function() {
      var idx;
      this.sketch = Sketch.create({
        container: document.getElementById("dhaakon-sketch-container")
      });
      this.sketch.mousemove = this.onmousemove;
      this.sketch.draw = this.draw;
      this.timeline = new TimelineMax({
        align: "start",
        onComplete: this.onTimelineComplete,
        stagger: 1.5,
        ease: SlowMo.ease
      });
      this.timeline.timeScale(1.4);
      EventManager.addListener(Events.WINDOW_RESIZE, this.onresize);
      if (this.currentIndex + 1 < this.max_index) {
        idx = this.currentIndex + 1;
      } else {
        idx = 0;
      }
      return this.changeImage(idx);
    };

    PhysicsDemo.prototype.delayScale = 1;

    PhysicsDemo.prototype.tweenIn = function() {
      var cb, particle, randX, randY, _i, _len, _onUpdate, _ref, _speed,
        _this = this;
      _ref = this.engine.particles;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        particle = _ref[_i];
        cb = function(e) {
          return e.moveTo(e.pos);
        };
        _onUpdate = function(e) {
          return cb(e);
        };
        randX = Math.random() * 0;
        randY = Math.random() * 0;
        _speed = particle.mass / particle.radius / 10;
        this.timeline.insert(TweenLite.to(particle.pos, _speed, {
          x: particle.behaviours[1].target.x - randX,
          y: particle.behaviours[1].target.y - randY,
          delay: Math.random() * this.delayScale,
          onUpdate: _onUpdate,
          onUpdateParams: [particle]
        }));
      }
      return this.timeline.play();
    };

    PhysicsDemo.prototype.createParticles = function(paths) {
      var count, particle, path, pathData, position, pull, _i, _j, _len, _len1, _ref;
      this.engine = new Physics();
      this.engine.integrator = new Verlet();
      count = 0;
      for (_i = 0, _len = paths.length; _i < _len; _i++) {
        path = paths[_i];
        _ref = path.pathData;
        for (_j = 0, _len1 = _ref.length; _j < _len1; _j++) {
          pathData = _ref[_j];
          particle = new Particle(max(this.min_mass, random(this.max_mass)));
          position = new Vector(random(this.sketch.width), random(this.sketch.height));
          this.count++;
          particle.endRadius = random(8);
          particle.setRadius = 0;
          particle.moveTo(position);
          particle.destX = pathData.x;
          particle.destY = pathData.y;
          particle.color = this.fills[Math.floor(this.fills.length * Math.random())];
          pull = new Attraction();
          pull.target.x = pathData.x + ((this.sketch.width / 2) - this.X_OFFSET);
          pull.target.y = pathData.y + ((this.sketch.height / 2) - this.Y_OFFSET);
          pull.strength = Math.max(5000 * Math.random(), 3000);
          particle.behaviours.push(this.avoidMouse, pull);
          this.engine.particles.push(particle);
        }
      }
      this.avoidMouse.setRadius(100);
      this.avoidMouse.strength = -this.AVOID_MOUSE_STRENGTH;
      return this.tweenIn();
    };

    PhysicsDemo.prototype.timerCallback = function() {
      var _this = this;
      return this.destroySketch((function() {
        return _this.createSketch();
      }));
    };

    PhysicsDemo.prototype.draw = function() {
      if (this.isPhysicsRunning) {
        this.engine.step();
      }
      this.sketch.shadowBlur = 0;
      this.sketch.shadowOffsetX = 0;
      this.sketch.shadowOffsetY = 0;
      this.sketch.fillStyle = 'rgba(' + [211, 211, 211, 0.17].join(',') + ')';
      this.sketch.fillRect(0, 0, this.sketch.width, this.sketch.height);
      if (this.counter < this.max_count) {
        this.counter++;
      } else {
        this.counter = 0;
        this.timerCallback();
      }
      this.avoidMouse.strength = -this.AVOID_MOUSE_STRENGTH;
      if (this.isDrawingParticles) {
        return this.drawParticles();
      }
    };

    PhysicsDemo.prototype.drawParticles = function() {
      var particle, _i, _len, _ref, _results, _type;
      _ref = this.engine.particles;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        particle = _ref[_i];
        if (this.destroy) {
          if (particle.radius > 0) {
            particle.radius -= this.DESTROY_SIZE;
          }
        } else {
          if (particle.radius < particle.endRadius) {
            particle.radius += this.DESTROY_SIZE;
          }
        }
        if (particle.radius > 0) {
          if (this.destroy) {
            _type = "stroke";
          } else {
            _type = "fill";
          }
          _results.push(this.drawCircle(particle.pos.x, particle.pos.y, particle.radius, 'fill', particle.color));
        } else {
          _results.push(void 0);
        }
      }
      return _results;
    };

    PhysicsDemo.prototype.drawCircle = function(x, y, radius, type, color) {
      this.sketch.fillStyle = color;
      this.sketch.beginPath();
      this.sketch.arc(x, y, radius, 0, Math.PI * 2);
      return this.sketch[type]();
    };

    PhysicsDemo.prototype.onmousemove = function() {
      this.avoidMouse.target.x = this.sketch.mouse.x;
      return this.avoidMouse.target.y = this.sketch.mouse.y;
    };

    PhysicsDemo.prototype.getSketch = function() {
      return this.sketch;
    };

    PhysicsDemo.prototype.destroySketch = function(cb) {
      var _this = this;
      this.destroy = true;
      EventManager.removeListener(Events.WINDOW_RESIZE, this.onresize);
      if (this.timeline._duration === 0) {
        this.reset();
      }
      this.timeline.eventCallback('onReverseComplete', function() {
        _this.destroy = false;
        _this.reset();
        if (cb) {
          return cb();
        }
      });
      this.timeline.timeScale(5.3);
      return this.timeline.reverse();
    };

    PhysicsDemo.prototype.reset = function() {
      this.counter = 0;
      this.sketch.stop();
      this.sketch.clear();
      this.sketch.destroy();
      return this.destroyParticles();
    };

    PhysicsDemo.prototype.destroyParticles = function() {
      return this.engine.destroy();
    };

    return PhysicsDemo;

  })();

  NodeViewer = (function() {
    function NodeViewer(src) {
      this.src = src;
      this.onloaded = __bind(this.onloaded, this);
      this.load();
    }

    NodeViewer.prototype.load = function() {
      var cb, options,
        _this = this;
      options = {
        type: 'GET',
        url: this.src,
        complete: this.onloaded,
        error: function(e) {
          return console.log(e);
        }
      };
      cb = function(data) {
        return console.log(data);
      };
      return $.ajax(options);
    };

    NodeViewer.prototype.onloaded = function(data) {
      var str;
      str = JSON.stringify(data.response);
      return;
      console.log(JSON.parse(data.response));
      this.data = eval(data.response);
      this.status = 'ready';
      return EventManager.emitEvent('onNodeDataLoaded', [this.data]);
    };

    return NodeViewer;

  })();

  CANVAS = '#dhaakon-sketch-container';

  mr = Math.random;

  mf = Math.floor;

  mmax = Math.max;

  mmin = Math.min;

  btw = function(x1, x2) {
    var t;
    t = (mr() * (x2 - x1)) + x1;
    return t;
  };

  Voronoi = (function() {
    Voronoi.prototype.numPoints = 100;

    Voronoi.prototype.canvas = null;

    Voronoi.prototype.ctx = null;

    Voronoi.prototype.voronoi = null;

    Voronoi.prototype.t = 0;

    Voronoi.prototype.numParticles = 40;

    Voronoi.prototype.pulls = [];

    Voronoi.prototype.stepSize = 8;

    Voronoi.prototype.X_OFFSET = 400;

    Voronoi.prototype.Y_OFFSET = -200;

    Voronoi.prototype.AVOID_MOUSE_STRENGTH = 25000;

    function Voronoi() {
      this.draw = __bind(this.draw, this);
      this.mousemove = __bind(this.mousemove, this);
      this.redraw = __bind(this.redraw, this);
      var cb, fn, point, tp, _i, _len, _ref,
        _this = this;
      this.nv = new NodeViewer('/json/tiger.json');
      cb = function(d) {
        return console.log(d);
      };
      EventManager.addListener('onNodeDataLoaded', cb);
      return;
      tp = new TypePath();
      this.width = $(window).width();
      this.height = $(window).height();
      fn = function(d) {
        return [Math.random() * _this.width, Math.random() * _this.height];
      };
      this.rand = d3.range(this.numPoints).map(fn);
      this.vertices = tp.getPaths()[0].points[0].pathData;
      _ref = this.vertices;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        point = _ref[_i];
        point[0] += (this.width / 2) - this.X_OFFSET;
        point[1] += (this.height / 2) + this.Y_OFFSET;
      }
      this.voronoi = d3.geom.voronoi().clipExtent([0.0], [this.width, this.height]);
      this.particle = new Particle(3);
      this.createSketch();
      this.redraw();
    }

    Voronoi.prototype.createPhysics = function() {
      var particle, pull, r1;
      console.log('b');
      this.engine = new Physics();
      this.engine.integrator = new Verlet;
      this.avoidMouse = new Attraction();
      while (--this.numParticles > 0) {
        particle = new Particle;
        particle.endRadius = random(8);
        particle.setRadius = 0;
        r1 = Math.floor(random(this.vertices.length));
        particle.moveTo(new Vector(this.vertices[r1][0], this.vertices[r1][1]));
        pull = new Attraction();
        pull.target.x = random(this.width);
        pull.target.y = random(this.height);
        pull.strength = 50;
        this.pulls.push(pull);
        particle.behaviours.push(pull);
        this.engine.particles.push(particle);
      }
    };

    Voronoi.prototype.redraw = function() {
      var path, triangle, _i, _len, _ref;
      this.triangles = this.voronoi.triangles(this.vertices);
      this.sketch.fillStyle = 'rgba(' + [211, 211, 211, 0.27].join(',') + ')';
      this.sketch.fillRect(0, 0, this.width, this.height);
      _ref = this.triangles;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        triangle = _ref[_i];
        this.createTriangle(triangle);
      }
      return;
      this.svg.html('');
      this.path = this.svg.append('g').selectAll('path');
      path = this.path.data(this.triangles);
      path.exit().remove();
      path.enter().append('path').attr('d', this.polygon).attr('fill', this.fill).attr('stroke', this.fill);
      return path.order();
    };

    Voronoi.prototype.createTriangle = function(triangle) {
      this.sketch.beginPath();
      this.sketch.moveTo(triangle[0][0], triangle[0][1]);
      this.sketch.lineTo(triangle[1][0], triangle[1][1]);
      this.sketch.lineTo(triangle[2][0], triangle[2][1]);
      this.sketch.lineTo(triangle[0][0], triangle[0][1]);
      this.sketch.fillStyle = this.fill();
      this.sketch.fill();
      this.sketch.strokeStyle = this.fill();
      return this.sketch.stroke();
    };

    Voronoi.prototype.fill = function(d) {
      var a, b, col, g, r;
      r = mf(mr() * btw(0, 255));
      g = mf(mr() * btw(55, 65));
      b = mf(mr() * btw(200, 205));
      a = 0.25;
      col = [r, g, b, a].join(',');
      return 'rgba(' + col + ')';
    };

    Voronoi.prototype.polygon = function(d) {
      return 'M' + d.join('L') + 'Z';
    };

    Voronoi.prototype.createSketch = function() {
      var opts;
      opts = {
        container: $(CANVAS)[0]
      };
      this.sketch = Sketch.create(opts);
      this.createPhysics();
      this.sketch.draw = this.draw;
      this.sketch.lineWidth = '0.1px';
      this.sketch.mousemove = this.mousemove;
    };

    Voronoi.prototype.mousemove = function(e) {};

    Voronoi.prototype.draw = function() {
      var f, particle, pull, x, y, _i, _j, _len, _len1, _ref, _ref1;
      console.log('a');
      this.t++;
      if (this.t % 100 === 1) {
        _ref = this.pulls;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          pull = _ref[_i];
          pull.target.x = random(this.width);
          pull.target.y = random(this.height);
        }
      }
      this.engine.step();
      f = 0;
      _ref1 = this.engine.particles;
      for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
        particle = _ref1[_j];
        x = particle.pos.x;
        y = particle.pos.y;
        this.vertices[f * this.stepSize] = [x, y];
        ++f;
      }
      this.redraw();
    };

    Voronoi.prototype.createSVG = function() {
      var _this = this;
      return this.svg = d3.select('body').append('svg').attr('width', this.width).attr('height', this.height).on("mousemove", function() {
        _this.currentMouse = d3.mouse($('svg')[0]);
        return _this.redraw();
      });
    };

    return Voronoi;

  })();

  RGB = (function() {
    function RGB() {
      this.draw = __bind(this.draw, this);
      var opts;
      opts = {
        container: $(CANVAS)[0],
        width: 255,
        height: 255,
        fullscreen: false
      };
      opts.container.style.width = '255px';
      opts.container.style.height = '255px';
      this.sketch = Sketch.create(opts);
      this.sketch.draw = this.draw;
    }

    RGB.prototype.draw = function(e) {
      return this.sketch.clear();
    };

    return RGB;

  })();

  init = function() {
    console.log('a');
    return new Voronoi();
  };

  $(window).ready((function() {
    return init();
  }));

}).call(this);
