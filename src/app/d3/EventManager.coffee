EventManager = new EventEmitter()
Events =
  CLOSE_EVENT       : "Close Event"
  SLIDE_EVENT_CLICK : "On Slide Click"
  WINDOW_RESIZE     : "On Window Resize"
  KEYBOARD_EVENT    : "On Key Press"
  BUTTON_GO_EVENT   : "On Button Go"
  VIDEO_CLOSE       : "On Video Close"


do () =>
  MIN_WIDTH = 1024
  MIN_HEIGHT = 768

  window.onkeydown = (event) =>
    EventManager.emitEvent Events.KEYBOARD_EVENT, [event]
  window.onresize = (e)=>
    #if window.innerHeight < MIN_HEIGHT then return
    #if window.innerWidth < MIN_WIDTH then return  
    EventManager.emitEvent Events.WINDOW_RESIZE, [e]

  $(window).on 'hashchange', (e)=> EventManager.emitEvent Events.URL_CHANGE, [e]
