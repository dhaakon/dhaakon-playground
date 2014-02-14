class TGS
	flickrSrc			:		Config.TGS.src
	studentsSrc		:		Config.TGS.students_src
	JSON_PATH			:		Config.Settings.jsonPath
	mapHeight			:		Config.Map.height
	mapWidth			:		Config.Map.width

	map						:	null
	renderer			: Config.Settings.renderer

	bookingInformation	:	null
	mapContainer				:	Config.Map.container

	svg						:	null
	container			:	null

	loader				:	null
	constructor		:		()->
		@mapWidth  = _w = $(window).width()
		@mapHeight = _h = $(window).height() 

		@loader			=		$('#loader-container')

		@renderer = $(@mapContainer).data().renderer
		@scale	  = $(@mapContainer).data().scale

		$(@mapContainer).css(
			width		:		_w,
			height	:		_h
		)

		@addListeners()
		@createMap()
	
	onTGSFlickrDataLoaded		:		(data)->
		@map.createPoints 'flickr', data, 'red'
		d3.json @studentsSrc, _.bind @onTGSStudentsDataLoaded, @

	onTGSStudentsDataLoaded		:		(data)->
		@map.createPoints 'students', data, 'blue'
		@map.drawLines ['students','flickr']

	createBookingData	:	()->
		@booking = new Booking @CSV_PATH
	
	addListeners			:	()->
		EventManager.addListener Events.MAP_LOADED,			@onMapLoaded
		#EventManager.addListener Events.BOOKING_LOADED, @onBookingLoaded
		
	onMapLoaded				:	()=>
		#@createBookingData()
		@loader.remove()
		d3.json @flickrSrc, _.bind @onTGSFlickrDataLoaded, @
		
	onBookingLoaded		:	( event )=>
		@map.createPoints @booking.data
		@bookingInformation		=	new BookingInformation()

		EventManager.addListener Events.MARKER_FOCUS, @onMarkerFocused

	onMarkerFocused		:	( event )=>
		@bookingInformation.changeTourTitle				event.booking_id
		@bookingInformation.changeTourCityTitle		event.tour_address
		@bookingInformation.changeBookerCityTitle	event.booker_country		

	createMap					:	()->
		@map = new Map @JSON_PATH, @mapWidth, @mapHeight, @mapContainer, @renderer, @scale
