/**
 *
 * Timeline Manager
 * @constructor
 *
 */


var Timeline = function (options) {
  this.currentframe = 0;
  this._prevTime = -1;
  this.callbacks = [];
  this._tween = new Tween();
  this.duration = options.duration;
  this.scene = null;

  this._setup();
  this._head = this._tail = null;
};

Timeline.prototype = {
  _isMouseDown:false,
  _tween:null,
  _currentPercentage:1,
  _prevTime: -1,
  _name:null,
  
  callbacks:[],

  /**
   * Clears the timeline of the tweens
   * @public
   */

  clearTweens : function(){
    this.callbacks = [];
    this._head = null;
    this._tail = null;
  },

  /**
   * First item in the linked list
   * @type {Timeline.TweenObject}
   */
  _head  : null,

  /**
   * Last item in the linked list
   * @type {Timeline.TweenObject}
   */
  _tail  : null,

  /**
   * Initialization function
   * @private
   */
  _setup:function () {
    this._tween.easing = Tween.Easing.Linear.easeNone;
    this._tween.duration = this.duration;
    this._tween.curve = [0, this.duration];
    this._tween._initProperties();
    this.onComplete = function(){}

    var self = this;
    this._tween.onAnimate = function (c) {
      if (c == self.duration){
        self.onComplete()
      }
      self._step(c);
      for (var aCallback in self.callbacks) {
        self.callbacks[aCallback](c);
      }
    };
  },

  /**
   * Activates and starts playing this timeline
   */
  start:function () {
    this._tween.play();
  },


  /**
   * Places the timeline at 'c'
   * @param c The absolute time to animate to
   * @private
   */
  _step:function (c) {

    if( this._prevTime < c ) {
      this._stepForward(c);
    } else {
      this._stepBackward(c);
    }
    this._prevTime = c;
  },

  /**
   * Iterates through the tweens in normal order, such that later ones overwrite previous ones
   * @param c The absolute time to animate to
   * @private
   */
  _stepForward: function(c) {
    var node = this._head;
    while( node ) {
      var b = node;
      node = b._next;
      if (c > b.startTime && c < b.endTime) {
        b.tween.goToPercentage( c - b.startTime );
      } else if (c > b.endTime) {
        b.tween.goToPercentage( b.tween.duration );
      }
    }
  },

  /**
   * Iterates through the tweens in reverse order, such that previous ones overwrite later ones
   * @param c The absolute time to animate to
   * @private
   */
  _stepBackward: function(c) {
    var node = this._tail;
    while( node ) {
      var b = node;
      node = b._prev;

      if (c > b.startTime && c < b.endTime) {
        b.tween.goToPercentage( c - b.startTime );
      } else if (c < b.startTime ) {
        b.tween.goToPercentage( 0 );
      }
    }
  },


  /**
   * Registers a tween into the timeline, uses startTime to place it into our Doubly Linked List
   * @param tween
   */
  registerTween:function (tween) {
    var tweenObject = new Timeline.TweenObject({
        startTime: tween.getStartTime(),
        endTime: tween.getEndTime(),
        tween: tween
      });
    tweenObject.tween.parent = this;

    // No tweens added yet - place at beginning
    if( !this._head ) {
      this._insertBeginning( tweenObject );
      return;
    }

    // Insert this tween before any objects whose start time is higher
    var node = this._head;
    while( node ) {
      var b = node;
      node = b._next;

      // Found a tween that starts after this one, insert the new tween before it
      if( b.startTime > tweenObject.startTime ) {
        this._insertBefore( b, tweenObject );
        this.outputTimes();
        return;
      }
    }

    // All tweens start before this one, place it at the end
    this._insertEnd( tweenObject );
  },


  /**
   * Inserts a newNode after node in the linked list
   * @param {Timeline.TweenObject} node
   * @param {Timeline.TweenObject} newNode
   * @private
   */
  _insertAfter: function( node, newNode ) {
    newNode._prev = node;
    newNode._next = node._next;

    if( node._next == null ) this._tail = newNode;
    else node._next._prev = newNode;

    node._next = newNode;
  },

  /**
   * Inserts newNode before node in the linked list
   * @param {Timeline.TweenObject} node
   * @param {Timeline.TweenObject} newNode
   * @private
   */
  _insertBefore: function( node, newNode ) {
    newNode._prev = node._prev;
    newNode._next = node;

    if( node._prev == null ) this._head = newNode;
    else node._prev._next = newNode;

    node._prev = newNode;
  },

  /**
   * Inserts a node at the beginning of the linked list
   * @param {Timeline.TweenObject} newNode
   * @private
   */
  _insertBeginning: function( newNode ) {
     if( this._head == null ) {
       this._head =  this._tail = newNode;
     } else {
       this._insertBefore( this._head, newNode );
     }
  },

  /**
   * Inserts a node at the end of the linked list
   * @param {Timeline.TweenObject} newNode
   * @private
   */
  _insertEnd: function( newNode ) {
    if( this._tail == null ) this._insertBeginning( newNode );
    else this._insertAfter( this._tail, newNode );
  },

  /**
   * Debug function
   */
  outputTimes: function() {
    return;
    var s = "";
    var node = this._head;
    while( node ) {
      var b = node;
      node = b._next;
      s += b.startTime + " > ";
    }
    console.log(s);
  },

  //// Accessors
  getRootTween: function() { return this._tween; }
};
