/**
 File:
  ServerRequest.js
 Created By:
  David Poyner, Mario Gonzalez
 Project:
  UBS NEO
 Abstract:
  Used by the timeline to store references to [Tween] objects
  Each [Timeline.TweenObject] is part of a linked list

 Basic Usage:

 Version:
  2.0
 */
var TweenObject = (function() {

  /**
   * @param options An object used to overwrite the default values used
   * @constructor
   */
  Timeline.TweenObject = function( options ) {
    this.startTime = Timeline.TweenObject.prototype.startTime;
    this.duration = Timeline.TweenObject.prototype.duration;
    this.isPlaying = Timeline.TweenObject.prototype.isPlaying;
    this.tween = null;

    this._next = this._prev = null;

    // Ovewrwrite default properties
    if(options) {
      for (var prop in options) {
        if( options.hasOwnProperty(prop) )
          this[prop] = options[prop];
      }
    }
  };

  Timeline.TweenObject.prototype = {
    /** @type {Number} */
    startTime: 0,

    /** @type {Number} */
    duration:  0,

    /** @type {Boolean} */
    isPlaying: false,

    /** @type {Boolean} */
    isControlled: false,

    /** @type {Tween} */
    tween: 0,

    /**
     * Linked list behavior
     * @type {Timeline.TweenObject}
     */
    _next: null,

    /**
     * Linked list behavior
     * @type {Timeline.TweenObject}
     */
    _prev: null
  }

})();
