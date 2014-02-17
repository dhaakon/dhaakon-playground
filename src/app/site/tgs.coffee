class TGS
	flickrSrc			:		Config.TGS.src
	studentsSrc		:		Config.TGS.students_src
	
	JSON_PATH			:		null
	speed					:		1e-2

	mapHeight			:		null	
	mapWidth			:		null
	
	velocity			:		null
	scale					:		null
	projectionKey	:		null
	rotation			:		null

	hasRotation		:		null
	hasLines			:		null
	hasGrid				:		null

	origin				:		0
	
	start					:		null
	map						:		null

	bookingInformation	:	null
	renderer			:	null
	mapContainer	:	null

	svg						:	null
	container			:	null

	loader				:	null

	constructor		:		()->
		@loadFromConfig()

		url					=		'http://' + window.location.hostname + '/'

		@mapHeight	=		@mapHeight or $(window).height()
		@mapWidth		=		@mapWidth or $(window).width()

		@loader			=		$('#loader-container')		
		@start			=		Date.now()
		@title			=		$('#location-title')
		@redisData	=		[]

		$(@mapContainer).css(
			width		:		@mapWidth,
			height	:		@mapHeight
		)

		@addListeners()
		@socket			=		new SocketClient(url, Config.userType)

	changeTitle		:		(event)=>
		console.log event
		console.log @title
		@title.animate( {'opacity': 1}, 'fast', ()=> @title.delay(1100).animate {opacity: 0}, 'slow')
		@title.html	'<p>' + event.location.title + '</p>'
		#@title.css('opacity', 1)

	loadFromConfig	:		()->
		@mapHeight			=		Config[Config.userType].Map.height
		@mapWidth				=		Config[Config.userType].Map.width
		
		@velocity				=		Config[Config.userType].Map.velocity/1000
		@scale					=		Config[Config.userType].Map.scale
		@projectionKey	=		Config[Config.userType].Map.projectionKey
		@rotation				=		Config[Config.userType].Map.rotation

		@renderer				=		Config[Config.userType].Settings.renderer
		@hasRotation		=		Config[Config.userType].Settings.hasRotation
		@hasLines				=		Config[Config.userType].Settings.hasLines
		@hasGrid				=		Config[Config.userType].Settings.hasGrid
		@renderer				=		Config[Config.userType].Settings.renderer
		@mapContainer		=		Config[Config.userType].Map.container

		@JSON_PATH			=		Config[Config.userType].Settings.jsonPath


	startRotation		:		()->
		framerate = 1000/60
		setInterval((=>@loop()), framerate)

	loop						:		()=>
		if @renderer is 'canvas' then @map.context.clearRect( 0,0,@mapWidth, @mapHeight)
		@map.projection = @map.projection.rotate([@origin + @velocity * (Date.now() - @start), -15])
		@map.drawMap()
		#return
		#@map.createPoints 'students', @studentData, 'blue'
		#@map.createPoints 'flickr', @flickrData, 'red'
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
	onSocketConnected	: ()=>
		@createMap()

	addListeners			:	()->

		EventManager.addListener Events.MAP_LOADED,			@onMapLoaded
		EventManager.addListener Events.SERVER_UPDATED,			@changeTitle
		EventManager.addListener Events.SOCKET_CONNECTED,		@onSocketConnected
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
		@map = new Map @JSON_PATH, @mapWidth, @mapHeight, @mapContainer, @renderer, @scale, @projectionKey, @hasGrid, @rotation
		if @hasGrid then @map.hasGrid = true
		

