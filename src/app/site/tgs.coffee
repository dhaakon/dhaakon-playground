class TGS
	flickrSrc			:		Config.TGS.src
	studentsSrc		:		Config.TGS.students_src
	JSON_PATH			:		Config.Settings.jsonPath
	mapHeight			:		Config.Map.height
	mapWidth			:		Config.Map.width
	speed					:		1e-2
	velocity			:		0.01
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
		@mapWidth  = _w = $(window).width()
		@mapHeight = _h = $(window).height()
		#@mapWidth  = _w = 1300 
		#@mapHeight = _h = 600

		@loader			=		$('#loader-container')

		@renderer				  = $(@mapContainer).data().renderer
		@scale						= $(@mapContainer).data().scale
		@projectionKey	  = $(@mapContainer).data().projectionkey
		@hasRotation		  = $(@mapContainer).data().rotate
		@hasLines				  = $(@mapContainer).data().lines
		@velocity				  = ($(@mapContainer).data().velocity / 10000) || @velocity

		console.log @velocity

		@start		=	Date.now()

		$(@mapContainer).css(
			width		:		_w,
			height	:		_h
		)

		@addListeners()
		@createMap()

	startRotation		:		()->
		framerate = 1000/60
		setInterval((=>@loop()), framerate)

	loop						:		()=>
		if @renderer is 'canvas' then @map.context.clearRect( 0,0,@mapWidth, @mapHeight)
		@map.projection = @map.projection.rotate([@origin + @velocity * (Date.now() - @start), -15])
		@map.drawMap()
		#return
		@map.createPoints 'students', @studentData, 'blue'
		@map.createPoints 'flickr', @flickrData, 'red'
		if @hasLines then @map.drawLines ['students','flickr']
	
	onTGSFlickrDataLoaded		:		(@flickrData)->
		@map.createPoints 'flickr', @flickrData, 'red'
		d3.json @studentsSrc, _.bind @onTGSStudentsDataLoaded, @

	onTGSStudentsDataLoaded		:		(@studentData)->
		@map.createPoints 'students', @studentData, 'blue'
		if @hasLines then @map.drawLines ['students','flickr']

		if @renderer is 'canvas' and @hasRotation then @startRotation()


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
		@map = new Map @JSON_PATH, @mapWidth, @mapHeight, @mapContainer, @renderer, @scale, @projectionKey
		

