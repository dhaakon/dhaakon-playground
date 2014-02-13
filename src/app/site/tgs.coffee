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
		@addListeners()
		@createMap()
	
		

	onTGSDataLoaded		:		(data)->
		@map.createPoints data

		return
		_main = d3.select('#main')
		
		_main.selectAll('p')
				 .data(data)
				 .enter()
				 .append('p')
				 .html((d)=> return d.location.title + '\t\n' + d.location.coords[0].latitude + '\t\t' + d.location.coords[0].longitude)

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
