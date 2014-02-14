class TGS
	flickrSrc			:		Config.TGS.src
	studentsSrc		:		Config.TGS.students_src
	JSON_PATH			:		Config.Settings.jsonPath
	mapHeight			:		Config.Map.height
	mapWidth			:		Config.Map.width
	speed					:		1e-2
	velocity			:		0.015
	origin				:		0
	start					:		null

	map						:	null
	renderer			: Config.Settings.renderer

	bookingInformation	:	null
	mapContainer				:	Config.Map.container

	svg						:	null
	container			:	null

	loader				:	null
	constructor		:		()->
		@mapWidth  = _w = 1460
		@mapHeight = _h = 800

		@loader			=		$('#loader-container')

		@renderer = $(@mapContainer).data().renderer
		@scale	  = $(@mapContainer).data().scale

		@start		=	Date.now()

		$(@mapContainer).css(
			width		:		_w,
			height	:		_h
		)

		@addListeners()
		@createMap()

	startRotation		:		()->
		d3.timer @loop

	loop						:		()=>
		@map.context.clearRect( 0,0,@mapWidth, @mapHeight)
		@map.projection = @map.projection.rotate([@origin + @velocity * (Date.now() - @start), -15])
		@map.drawMap()
		#return
		#@map.createPoints 'students', @studentData, 'blue'
		#@map.createPoints 'flickr', @flickrData, 'red'

	
	onTGSFlickrDataLoaded		:		(@flickrData)->
		@map.createPoints 'flickr', @flickrData, 'red'
		d3.json @studentsSrc, _.bind @onTGSStudentsDataLoaded, @

	onTGSStudentsDataLoaded		:		(@studentData)->
		@map.createPoints 'students', @studentData, 'blue'
		@map.drawLines ['students','flickr']
		if @renderer is 'canvas' then @startRotation()


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
		

