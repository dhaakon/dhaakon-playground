class TGS
	src						:		Config.TGS.src
	JSON_PATH			:	Config.Settings.jsonPath
	mapHeight			:	Config.Map.height
	mapWidth			:	Config.Map.width

	map						:	null

	bookingInformation	:	null
	mapContainer				:	Config.Map.container

	svg						:	null
	container			:	null

	constructor		:		()->
		@mapWidth  = _w = $(window).width()
		@mapHeight = _h = $(window).height() - 100

		$(@mapContainer).css(
			width		:		_w,
			height	:		_h
		)

		@addListeners()
		@createMap()
	
	onTGSDataLoaded		:		(data)->
		@map.createPoints data

	createBookingData	:	()->
		@booking = new Booking @CSV_PATH
	
	addListeners			:	()->
		EventManager.addListener Events.MAP_LOADED,			@onMapLoaded
		#EventManager.addListener Events.BOOKING_LOADED, @onBookingLoaded
		
	onMapLoaded				:	()=>
		#@createBookingData()
		d3.json @src, _.bind @onTGSDataLoaded, @

	onBookingLoaded		:	( event )=>
		@map.createPoints @booking.data
		@bookingInformation		=	new BookingInformation()

		EventManager.addListener Events.MARKER_FOCUS, @onMarkerFocused

	onMarkerFocused		:	( event )=>
		@bookingInformation.changeTourTitle				event.booking_id
		@bookingInformation.changeTourCityTitle		event.tour_address
		@bookingInformation.changeBookerCityTitle	event.booker_country		

	createMap					:	()->
		@map = new Map @JSON_PATH, @mapWidth, @mapHeight, @mapContainer
