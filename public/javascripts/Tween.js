/**
 *    @constructor
 *    @description A lightweight <b>Tween</b> class independant of Third Party libraries (aside from Robert Penner's easing functions). The engine has Paul Irish's
 *    requestAnimationFrame shim built in allowing for consistent animations across browsers and devices.
 *    <br>
 *    @example
 *    <b><u>Properties Example</b></u>
 *
 *    var tween = new Tween();
 *    target = document.getElementById("target");
 *
 *    var propertyOptions = {
 *       node: target,
 *       duration: 1000,
 *       properties:{height:{start:300, end:4000, unit:"px"},
 *                   width:{start:200, end:3000, unit:"px"}},
 *    }
 *
 *    tween.to(propertyOptions);
 *    @link <a href="../examples/PropertyExample.html">Property Example</a>
 *    @link <a href="../examples/CurveExample.html">Curve Example</a>
 *    @link <a href="../examples/LineExample.html">Line Example</a>
 *
 *    @example
 *
 *
 *    <b><u>Curve Example</b></u>
 *
 *    var tween = new Tween();
 *    target = document.getElementById("target");
 *
 *    var curveOptions = {
 *       node: target,
 *       duration: 1000,
 *       curve:[0, 100],
 *       onAnimate:function(c){
 *        this.node.style.width = c + "px"
 *    }
 *
 *    tween.to(curveOptions);
 *    @example
 *
 *
 *    <b><u>Line Example</b></u>
 *
 *    var tween = new Tween();
 *    target = document.getElementById("target");
 *
 *    var lineOptions = {
 *       node: target,
 *       duration: 1000,
 *       curve:new Line([0, 0],[100,200]),
 *       onAnimate:function(c){
 *        this.node.style.width = c[0] + "px"
 *        this.node.style.left = c[1] + "px"
 *       }
 *    }
 *
 *    tween.to(lineOptions);
 *
 *
 *    @property {function} onEnd A function to be called at the end of the Tween.
 *    @property {function} onBegin A function to be called at the beginning of the Tween.
 *    @property {function} onAnimate A function to be called at every step of the Tween.
 *    @property {number} delay The delay before the  Tween starts.
 *    @property {boolean} isAnimating (read-only) Boolean determining if the Tween is in animating state.
 *    @property {boolean} isReversed (read-only) Boolean determining if the Tween is reversed.
 *    @property {boolean} isPaused (read-only) Boolean determining if the Tween is in the paused state.
 *    @property {number} percentage (read-only) The percentage of the Tween's completion.
 *    @property {object} properties The properties object which is used to create the motion objects.
 *    @property {array} curve The curves object which is used to create the motion objects.
 *    @property {function} easing The easing function to be used for the tween.
 *    @property {object} node An object which the Tween will animate.
 *    @property {number} duration The duration of the tween (in milliseconds).
 *    @property {number} _previousTime (read-only) The previous time from the last step.
 *    @property {number} _currentTime (read-only) The current time for the current step.
 *    @property {number} _startTime (read-only) The initial start time for the tween.
 *    @property {number} _delta (read-only) The difference between the last and first step.
 *    @property {number} _t (read-only) The time value to pass to the easing function.
 *    @property {array}  _motionStack (read-only) The motion objects which will be tweened.
 */

var Tween = function (options) {
  this.onEnd = null;
  this.onBegin = null;
  this.onAnimate = null;
  this.delay = 0;
  this.node = null;
  this.duration = 0;
  this.isAnimating = false;
  this.isReversed = false;
  this.isPaused = false;
  this.isControlled = false;
  this.properties = null;
  this.curve = [0, 1];
  this.easing = Tween.Easing.Quad.easeOut;
  this._previousTime = null;
  this._currentTime = null;
  this._startTime = 0;
  this._endTime = null;
  this._delta = null;
  this._t = 0;
  this._motionStack = null;

  //setup options
  if (options) {
    // Iterate through the options
    for (key in options) {
      // Assign our properties
      this[key] = options[key];
    }
    this._initProperties();
  }

  this._t = -this.delay;
}

Tween.prototype = {
  _initProperties:function () {
    if (this._motionStack == null) {
      this._motionStack = [];
      if (this.properties != null) {
        this._setMotionFromProperty();
      } else {
        this._setMotionFromCurve();
      }
    }

  },
  _callbacks:{
    onEnd:[],
    onBegin:[],
    onComplete:[]
  },
  /**
   * Private method which creates a MotionObject based on the curves set in the Tween Options before the start of the tween.
   * @private  {object}    Tween._setMotionFromCurve
   * @property {object}
   *
   */
  _setMotionFromCurve:function () {
    var c = this.curve;

    if (c instanceof Tween.Line == false) {
      var _mo = new MotionObject();
      _mo.d = this.duration;
      _mo.b = c[0];
      _mo.c = c[1] - c[0];
      this._motionStack.push(_mo);
    } else {
      var _c1 = c.curves[0];
      var _c2 = c.curves[1];

      for (var i = 0; i < _c1.length; ++i) {
        var _mo = new MotionObject();

        _mo.b = _c1[i];
        _mo.c = _c2[i] - _c1[i];
        this._motionStack.push(_mo);
      }
    }
  },

  /**
   *  Private method which creates a MotionObject based on the property Object passed in
   *  @private {object}     Tween._setMotionFromProperty
   *  @param   {object}     properties           The properties object which should contain standard CSS properties.
   *
   */

  _setMotionFromProperty:function () {
    // Each object in the properties object should be a CSS style
    for (var property in this.properties) {
      var _mo = new MotionObject();
      _mo.prop = property;
      var _property = this.properties[property];
      // If this is an object parse
      // // TODO: webkit, color tranforms: further detection and proceeding parsing
      //
      if (typeof _property == "object") {
        for (_p in _property) {
          if (_p == "begin") _mo.b = _property[_p];
          if (_p == "end") {
            _mo.c = _property[_p] - _mo.b;
          }
          if (_p == "unit") _mo.unit = _property[_p];
        }
        // If not use the value as the end
      } else {
        this.change = _property - this.begin;
      }

      this._motionStack.push(_mo);
    }
  },

  /**
   * Starts the tween according to the delay if any
   * @private {object}    Tween._start
   *
   */

  _start:function () {
    this._currentTime = 0;
    this._startTime = this.delay;

    this._endTime = (this.delay == 0) ? this.duration : this.duration;


    if (this.onBegin != null) this.onBegin();
    this._previousTime = Date.now();
    this.isAnimating = true;

    var self = this;
    //setTimeout(function () { self._update();}, this.delay);
    self._update()
  },

  /**
   * Steps the tween
   * @private {object}    Tween._step
   *
   */

  _step:function () {
    // Get the current time
    this._currentTime = Date.now();
    // Get the difference between the current time and the last time
    this._delta = this._currentTime - this._previousTime;
    // Bottleneck the difference if it is too high
    this._delta = Math.min(this._delta, 25);

    // If we are moving forward
    if (!this.isReversed) {
      // If the time and the difference is less than the duration
      if (this._t + this._delta < this._endTime) {
        // Add this and the adjusted frame step to the tween value
        this._t = this._delta + this._t;
        // Continue to the next sp
        if (!this.isControlled) this._update();

        if (this._t < 0) return 

        this._setProperties();
        // If we are at the end of the tween
      } else {
        // Set the tween value to the final step
        this._t = this.duration;
        this._setProperties();
        if (this._callbacks.onComplete.length > 0) {
          for( var callback in this._callbacks.onComplete){
            aCallback = this._callbacks.onComplete[callback]
            aCallback()
          }
        }

        // End the tween
        this._stop();
      }
      // If we are moving in reverse
    } else {
      // If the tween value is greater than the start (0)
      if (this._t > 0) {
        // Tween value minus the adjusted frame step or the beginning value
        this._t = (this._t - this._delta > 0) ? this._t - this._delta : 0;
        // Continue to the next step
        this._update();
        this._setProperties();

      } else {
        this._stop();

      }
    }
    // If there is an onAnimate callback
    // Change the time
    this._previousTime = this._currentTime;

  },

  /**
   * Stops the tween
   * @private {object}    Tween._stop
   *
   */
  _setProperties:function () {
    // Iterate through the motion stack to get all our motion objects
    for (var tween in this._motionStack) {
      // Assign a temporary motion object
      var motionObject = this._motionStack[tween];
      // If it has a property value
      if (motionObject.prop != null) {
        // Assign the value to the tween return value
        this.node.style[motionObject.prop] = this.easing(this._t, motionObject.b, motionObject.c, this._endTime) + motionObject.unit;
        // If there is an onAnimate function return the tween with a beginning of 0 and an end of 1
        if (this.onAnimate != null) var c = this.easing(this._t, 0, 1, this.duration);
        // If there is no property value and only a curve value
      } else {
        // If we only have one curve
        if (this._motionStack.length == 1) {
          // Assign the onAnimate parameter to the one curve
          var c = this.easing(this._t, motionObject.b, motionObject.c, this.duration);
          // If there are multiple curves
        } else {
          // Assign the onAnimate parameter to an empty array
          var c = [];
          // Iterate through the motionObjects
          for (motionObject in this._motionStack) {
            var _m = this._motionStack[motionObject];
            // Add the return paramater to the array
            c.push(this.easing(this._t, _m.b, _m.c, this.duration));
          }
        }
      }
      if (this.onAnimate != null) this.onAnimate(c, this);
    }
  },
  /**
   * Stops the tween
   * @private {object}    Tween._stop
   *
   */

  _stop:function () {
    this.isAnimating = false;
    if (this.onEnd != null && !this.isPaused) this.onEnd();
  },

  /**
   * Updates the tween
   * @private {object}    Tween._update
   *
   */

  _update:function (c) {
    var self = this;
    if (this.isAnimating == true) requestAnimationFrame(function () {self._step()});
  },
  /**
   * Gets the motion object at a percentage of the frame
   * @public {function}    Tween.goToPercentage
   * @param {int}    percent the percentage to grab the motion object
   *
   */

  goToPercentage:function (percent) {
    if( this._t == percent ) return;
    this.isAnimating = false;
    this._t = percent;
    this._setProperties();
  },
  /**
   * Get the start time
   * @public {function}    Tween.goToPercentage
   * @return {int}    percent the percentage to grab the motion object
   *
   */

  getStartTime:function () {
    return this._startTime + this.delay;
  },

  /**
   * Set the start time
   * @public {function}    Tween.goToPercentage
   * @return {int}    percent the percentage to grab the motion object
   *
   */

  setStartTime:function (time) {
    this._startTime = time;
    this._endTime = this._startTime + this.duration;
  },
  /**
   * Get the end time
   * @constructor
   *
   */
  getEndTime:function () {
    return this._startTime + this.duration;
  },


  /**
   * Reverses the tween
   * @public {object}    Tween.reverse
   *
   */

  reverse:function () {
    this.isReversed = (this.isReversed == false) ? this.isReversed = true : this.isReversed = false;
  },

  /**
   * Checks to see if the tween is paused. If so, resumes the tween.
   * @public {object}    Tween.resume
   *
   */

  resume:function () {
    if (!this.isPaused) return;
    // Reset our time settings
    this._delta = 0;
    this._previousTime = Date.now();
    // Set our properties
    this.isPaused = false;
    this.isAnimating = true;
    // Resume the tween
    this._update();
  },

  /**
   * Pauses the tween
   * @public {object}    Tween.pause
   *
   */

  pause:function () {
    // No need to pause a stopped tween
    if (this.isAnimating == false) return;
    // Set the properties
    this.isAnimating = false;
    this.isPaused = true;
    this._step();
  },

  /**
   * Initializes the tween animation.
   * @public {object}    Tween.play
   * @param {object} options The options object.
   * @example
   * var options = {
   *  node:this,
   *  duration:100,
   *  properties:{width:400}
   * }
   *
   * tween.play(options)
   */

  play:function (options) {
    //setup options
    if (options) {
      // Iterate through the options
      for (key in options) {
        // Assign our properties
        this[key] = options[key];
      }
    }
    // Grab the motion objects
    this._initProperties();
    // Let her rip
    this._start();
  },

  //// Accesors
  getValue:function () { return this._t; }
};

/**
 Create a MotionObject which the Tween Engine uses to modify a given value
 @constructor
 @property {number} b          the begin value for the tween
 @property {number} c          the change value for the tween
 @property {number} t          the time value for the tween
 @property {string} prop       the property which the tween manipulates (if any)
 @property {string} unit       the unit which determines the scale of the property (if any)
 */

function MotionObject() {
  this.b = 0;
  this.c;
  this.t;
  this.prop = null;
  this.unit = "";
}

/**
 Create a Line Object or an array containing an array of start values and an array of end values
 @constructor
 @param {array} a              an Array of start points
 @param {array} b              an Array of end points
 */

Tween.Line = function (a, b) {
  if (a.length != b.length) throw new Error("Uneven Amount of Lines " + a.length + " != " + b.length);
  this.curves = [a, b];
};

Tween.Line.prototype.toConstructorString = function() {
  return "new Tween.Line([" + this.curves[0].toString() + "],[" + this.curves[1].toString() + "])";
};

/** @namespace */
Tween.Easing = {
  /** @property {object} Back */
  Back:{
    /**
     * @public {function} Easing.Back.easeIn
     * @public {function} Easing.Back.easeOut
     * @public {function} Easing.Back.easeInOut
     * */
    easeIn:function (t, b, c, d, s) {
      if (s == undefined) s = 1.70158;
      return c * (t /= d) * t * ((s + 1) * t - s) + b;
    },
    easeOut:function (t, b, c, d, s) {
      if (s == undefined) s = 1.70158;
      return c * ((t = t / d - 1) * t * ((s + 1) * t + s) + 1) + b;
    },
    easeInOut:function (t, b, c, d, s) {
      if (s == undefined) s = 1.70158;
      if ((t /= d / 2) < 1) return c / 2 * (t * t * (((s *= (1.525)) + 1) * t - s)) + b;
      return c / 2 * ((t -= 2) * t * (((s *= (1.525)) + 1) * t + s) + 2) + b;
    }
  },
  /** @property {object} Bounce */
  Bounce:{
    /**
     * @public {function} Easing.Bounce.easeIn
     * @public {function} Easing.Bounce.easeOut
     * @public {function} Easing.Bounce.easeInOut
     * */
    easeOut:function (t, b, c, d) {
      if ((t /= d) < (1 / 2.75)) {
        return c * (7.5625 * t * t) + b;
      } else if (t < (2 / 2.75)) {
        return c * (7.5625 * (t -= (1.5 / 2.75)) * t + .75) + b;
      } else if (t < (2.5 / 2.75)) {
        return c * (7.5625 * (t -= (2.25 / 2.75)) * t + .9375) + b;
      } else {
        return c * (7.5625 * (t -= (2.625 / 2.75)) * t + .984375) + b;
      }
    },
    easeIn:function (t, b, c, d) {
      easeOut = function (t, b, c, d) {
      if ((t /= d) < (1 / 2.75)) {
        return c * (7.5625 * t * t) + b;
      } else if (t < (2 / 2.75)) {
        return c * (7.5625 * (t -= (1.5 / 2.75)) * t + .75) + b;
      } else if (t < (2.5 / 2.75)) {
        return c * (7.5625 * (t -= (2.25 / 2.75)) * t + .9375) + b;
      } else {
        return c * (7.5625 * (t -= (2.625 / 2.75)) * t + .984375) + b;
      }
      }
      return c - easeOut(d - t, 0, c, d) + b; 
    },
    easeInOut:function (t, b, c, d) { 
      easeOut =function (t, b, c, d) {
      if ((t /= d) < (1 / 2.75)) {
        return c * (7.5625 * t * t) + b;
      } else if (t < (2 / 2.75)) {
        return c * (7.5625 * (t -= (1.5 / 2.75)) * t + .75) + b;
      } else if (t < (2.5 / 2.75)) {
        return c * (7.5625 * (t -= (2.25 / 2.75)) * t + .9375) + b;
      } else {
        return c * (7.5625 * (t -= (2.625 / 2.75)) * t + .984375) + b;
      }
      }
      if (t < d / 2) return easeOut(t * 2, 0, c, d) * .5 + b; else return easeOut(t * 2 - d, 0, c, d) * .5 + c * .5 + b;
    }
  },
  /** @property {object} Circ */
  Circ:{
    /**
     * @public {function} Easing.Circ.easeIn
     * @public {function} Easing.Circ.easeOut
     * @public {function} Easing.Circ.easeInOut
     * */
    easeIn:function (t, b, c, d) {return c * (t /= d) * t * t + b;},
    easeOut:function (t, b, c, d) {return c * ((t = t / d - 1) * t * t + 1) + b;},
    easeInOut:function (t, b, c, d) {
      if ((t /= d / 2) < 1) return c / 2 * t * t * t + b;
      return c / 2 * ((t -= 2) * t * t + 2) + b;
    }
  },
  /** @property {object} Cubic */
  Cubic:{
    /**
     * @public {function} Easing.Cubic.easeIn
     * @public {function} Easing.Cubic.easeOut
     * @public {function} Easing.Cubic.easeInOut
     * */
    easeIn:function (t, b, c, d) {return c * (t /= d) * t * t + b;},
    easeOut:function (t, b, c, d) {return c * ((t = t / d - 1) * t * t + 1) + b;},
    easeInOut:function (t, b, c, d) {
      if ((t /= d / 2) < 1) return c / 2 * t * t * t + b;
      return c / 2 * ((t -= 2) * t * t + 2) + b;
    }
  },
  /** @property {object} Elastic */
  Elastic:{
    /**
     * @public {function} Easing.Elastic.easeIn
     * @public {function} Easing.Elastic.easeOut
     * @public {function} Easing.Elastic.easeInOut
     * */
    easeIn:function (t, b, c, d, a, p) {
      if (t == 0) return b;
      if ((t /= d) == 1) return b + c;
      if (!p) p = d * .3;
      if (!a || a < Math.abs(c)) {
        a = c;
        var s = p / 4;
      } else {
        var s = p / (2 * Math.PI) * Math.asin(c / a);
      }
      return -(a * Math.pow(2, 10 * (t -= 1)) * Math.sin((t * d - s) * (2 * Math.PI) / p)) + b;
    },
    easeOut:function (t, b, c, d, a, p) {
      if (t == 0) return b;
      if ((t /= d) == 1) return b + c;
      if (!p) p = d * .3;
      if (!a || a < Math.abs(c)) {
        a = c;
        var s = p / 4;
      } else {
        var s = p / (2 * Math.PI) * Math.asin(c / a);
      }
      return (a * Math.pow(2, -10 * t) * Math.sin((t * d - s) * (2 * Math.PI) / p) + c + b);
    },
    easeInOut:function (t, b, c, d, a, p) {
      if (t == 0) return b;
      if ((t /= d / 2) == 2) return b + c;
      if (!p) p = d * (.3 * 1.5);
      if (!a || a < Math.abs(c)) {
        a = c;
        var s = p / 4;
      } else {
        var s = p / (2 * Math.PI) * Math.asin(c / a);
      }
      if (t < 1) return -.5 * (a * Math.pow(2, 10 * (t -= 1)) * Math.sin((t * d - s) * (2 * Math.PI) / p)) + b;
      return a * Math.pow(2, -10 * (t -= 1)) * Math.sin((t * d - s) * (2 * Math.PI) / p) * .5 + c + b;
    }
  },
  /** @property {object} Expo */
  Expo:{
    /**
     * @public {function} Easing.Expo.easeIn
     * @public {function} Easing.Expo.easeOut
     * @public {function} Easing.Expo.easeInOut
     * */
    easeIn:function (t, b, c, d) {return (t == 0) ? b : c * Math.pow(2, 10 * (t / d - 1)) + b;},
    easeOut:function (t, b, c, d) {return (t == d) ? b + c : c * (-Math.pow(2, -10 * t / d) + 1) + b;},
    easeInOut:function (t, b, c, d) {
      if (t == 0) return b;
      if (t == d) return b + c;
      if ((t /= d / 2) < 1) return c / 2 * Math.pow(2, 10 * (t - 1)) + b;
      return c / 2 * (-Math.pow(2, -10 * --t) + 2) + b;
    }
  },
  /** @property {object} linear */
  Linear:{
    /**
     * @public {function} Easing.linear.easeIn
     * @public {function} Easing.linear.easeOut
     * @public {function} Easing.linear.easeInOut
     * @public {function} Easing.linear.easeNone
     * */
    easeNone:function (t, b, c, d) {return c * t / d + b;},
    easeIn:function (t, b, c, d) {return c * t / d + b;},
    easeOut:function (t, b, c, d) {return c * t / d + b;},
    easeInOut:function (t, b, c, d) {return c * t / d + b;}
  },
  /** @property {object} Quad */
  Quad:{
    /**
     * @public {function} Easing.Quad.easeIn
     * @public {function} Easing.Quad.easeOut
     * @public {function} Easing.Quad.easeInOut
     * */
    easeIn:function (t, b, c, d) {return c * (t /= d) * t + b;},
    easeOut:function (t, b, c, d) {return -c * (t /= d) * (t - 2) + b;},
    easeInOut:function (t, b, c, d) {
      if ((t /= d / 2) < 1) return c / 2 * t * t + b;
      return -c / 2 * ((--t) * (t - 2) - 1) + b;
    }
  },
  /** @property {object} Quart */
  Quart:{
    /**
     * @public {function} Easing.Quart.easeIn
     * @public {function} Easing.Quart.easeOut
     * @public {function} Easing.Quart.easeInOut
     * */
    easeIn:function (t, b, c, d) {return c * (t /= d) * t * t * t + b;},
    easeOut:function (t, b, c, d) {return -c * ((t = t / d - 1) * t * t * t - 1) + b;},
    easeInOut:function (t, b, c, d) {
      if ((t /= d / 2) < 1) return c / 2 * t * t * t * t + b;
      return -c / 2 * ((t -= 2) * t * t * t - 2) + b;
    }
  },
  /** @property {object} Quint */
  Quint:{
    /**
     * @public {function} Easing.Quint.easeIn
     * @public {function} Easing.Quint.easeOut
     * @public {function} Easing.Quint.easeInOut
     * */
    easeIn:function (t, b, c, d) {return c * (t /= d) * t * t * t * t + b;},
    easeOut:function (t, b, c, d) {return c * ((t = t / d - 1) * t * t * t * t + 1) + b;},
    easeInOut:function (t, b, c, d) {
      if ((t /= d / 2) < 1) return c / 2 * t * t * t * t * t + b;
      return c / 2 * ((t -= 2) * t * t * t * t + 2) + b;
    }
  },

  /**
   * Given a constructor string (from JSON from example), will return the fully qualified name for the constructor object
   * @param tweenFunctionString A tweening function as a string, for example: "function (t, b, c, d) {return c * (t /= d) * t * t * t * t + b;},"
   * @return {String}           Fully qualified constructor name, for example: "Tween.Easing.Quint.easeOut"
   */
  getTweenConstructor: function( tweenFunctionString ) {
    var constructor = "Tween.Easing";
    for(var aTweenType in Tween.Easing ) {
      for(var anEasingType in Tween.Easing[aTweenType] ){
        if( Tween.Easing[aTweenType][anEasingType].toString() == tweenFunctionString ){
          return constructor + "." + aTweenType + "." + anEasingType;
        }
      }
    }

    return null;
  }
};
(function() {
    var lastTime = 0;
    var vendors = ['ms', 'moz', 'webkit', 'o'];
    for(var x = 0; x < vendors.length && !window.requestAnimationFrame; ++x) {
        window.requestAnimationFrame = window[vendors[x]+'RequestAnimationFrame'];
        window.cancelAnimationFrame = window[vendors[x]+'CancelAnimationFrame'] 
                                   || window[vendors[x]+'CancelRequestAnimationFrame'];
    }
 
    if (!window.requestAnimationFrame)
        window.requestAnimationFrame = function(callback, element) {
            var currTime = new Date().getTime();
            var timeToCall = Math.max(0, 16 - (currTime - lastTime));
            var id = window.setTimeout(function() { callback(currTime + timeToCall); }, 
              timeToCall);
            lastTime = currTime + timeToCall;
            return id;
        };
 
    if (!window.cancelAnimationFrame)
        window.cancelAnimationFrame = function(id) {
            clearTimeout(id);
        };
}());
