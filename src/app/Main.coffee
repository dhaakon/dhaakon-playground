#import Config.coffee
#import panels/BookingInformation.coffee
#import Booking.coffee
#import Events.coffee
#import Map.coffee

class Main
	JSON_PATH			:	Config.Settings.jsonPath	
	CSV_PATH			:	Config.Settings.csvPath

	mapHeight			:	Config.Map.height
	mapWidth			:	Config.Map.width

	map					:	null

	bookingInformation	:	null
	mapContainer		:	Config.Map.container

	svg					:	null
	container			:	null

	constructor	:	()->
		#@mapHeight = $(window).height()
		#@mapWidth = $(window).width()

		@addListeners()
		@createMap()

	createBookingData	:	()->
		@booking = new Booking @CSV_PATH
	
	addListeners	:	()->
		EventManager.addListener Events.MAP_LOADED,		@onMapLoaded
		EventManager.addListener Events.BOOKING_LOADED, @onBookingLoaded
		
	onMapLoaded		:	()=>
		@createBookingData()

	onBookingLoaded		:	( event )=>
		@map.createPoints @booking.data
		@bookingInformation		=	new BookingInformation()

		EventManager.addListener Events.MARKER_FOCUS, @onMarkerFocused

	onMarkerFocused		:	( event )=>
		@bookingInformation.changeTourTitle			event.booking_id
		@bookingInformation.changeTourCityTitle		event.tour_address
		@bookingInformation.changeBookerCityTitle	event.booker_country		

	createMap	:	()->
		@map = new Map @JSON_PATH, @mapWidth, @mapHeight, @mapContainer

$(document).ready( (=> new Main() ) )
