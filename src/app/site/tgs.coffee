class TGS
	flickrSrc			:		Config.TGS.src
	studentsSrc		:		Config.TGS.students_src
	facultySRC		:		Config.TGS.faculty_src
	
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
	classes				: ['grade-9', 'grade-10', 'grade-11','grade-12', 'faculty','location']

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
		@title.animate( {'opacity': 1}, 'fast', ()=> @title.delay(1100).animate {opacity: 0}, 'slow')
		@title.html	'<p>' + event.location.title + '</p>'

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
		#@map.createPoints 'students',	@studentData,	'blue'
		#@map.createPoints 'flickr',		@flickrData,	'red'
		if @hasLines then @map.drawLines [	'students',	'location'	]
	
	onTGSFlickrDataLoaded		:		(@flickrData)->
		@map.createPoints 'location', @flickrData, 'red'
		d3.json @studentsSrc, _.bind @onTGSStudentsDataLoaded, @

	onTGSFacultyLoaded		:		(@facultyData)->
		@map.createPoints 'faculty', @facultyData, 'red'

	onTGSStudentsDataLoaded		:		(@studentData)->
		@map.createPoints 'students', @studentData, 'blue'

		if @hasLines then @map.drawLines ['students','location']
		if @renderer is 'canvas' and @hasRotation then @startRotation()

	createBookingData	:	()->
		@booking = new Booking @CSV_PATH

	onSocketConnected	: ()=>
		@createMap()
		@addPanelHover()

	addPanelHover			:		()->
		panel = $('.marker-type li')

		fn = (event)=>
			s = event.currentTarget.id
			l = $('.' + s)

			_v = (el, idx, arr) =>

				_m = (d)=>
					$('.' + s).off 'mouseout'
					_.each @classes, (el, idx, arr)-> $('.' + el).css('opacity', 1)

				if el is s
					$('.' + s).on 'mouseout', _m
					_u = 1
				else
					u =0

				$('.' + el).css('opacity', _u)
			_.each @classes, _v


		panel.on 'mouseover', fn

	addListeners			:	()->

		EventManager.addListener Events.MAP_LOADED,			@onMapLoaded
		EventManager.addListener Events.SERVER_UPDATED,			@changeTitle
		EventManager.addListener Events.SOCKET_CONNECTED,		@onSocketConnected
		#EventManager.addListener Events.BOOKING_LOADED, @onBookingLoaded
		
	onMapLoaded				:	()=>
		#@createBookingData() 
		@loader.remove()
		d3.json @flickrSrc, _.bind @onTGSFlickrDataLoaded, @
		d3.json @facultySRC, _.bind @onTGSFacultyLoaded, @
				
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
		

