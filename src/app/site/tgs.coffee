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
	renderer						:	null
	mapContainer				:	null

	svg						:	null
	container			:	null

	loader				:	null
	classes				: [	
											'student',
											'faculty',
											'past-location',
											'current-location',
											'future-location',
											'tedxteen',
											'facebook'	
									]

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
		if typeof event.location is "string" then l = event.location else l = event.location.title

		if Config.userType == 'user'
			el = $ '#marker-icon'
			el.removeClass 'active'
			el.addClass 'inactive'

		@title.css( {'opacity': 1})
		@title.html	'<p>' + l + '</p>'

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

		if @hasLines then @map.drawLines [	'students',	'location'	]
	
	onTGSFlickrDataLoaded			:		(@flickrData)->
		@map.createPoints 'location', @flickrData, 'red'
		d3.json @studentsSrc, _.bind @onTGSStudentsDataLoaded, @

	onTGSFacultyLoaded				:		(@facultyData)->
		@map.createPoints 'faculty', @facultyData, 'red'

	onTGSStudentsDataLoaded		:		(@studentData)->
		@map.createPoints 'students', @studentData, 'blue'

		if @hasLines then @map.drawLines ['students','location']
		if @renderer is 'canvas' and @hasRotation then @startRotation()

	createBookingData	:	()->
		@booking = new Booking @CSV_PATH

	onSocketConnected	: ()=>
		console.log 'socket connected'
		
		@createMap()
		@addPanelHover()

	addPanelHover			:		()->
		panel = $('.marker-type li')

		fn = (event)=>
			s = event.currentTarget.id
			l = $('.' + s)
			e = $('#' + s)
			ts = 300	

			_v = (el, idx, arr) =>

				_m = (d)=>
					_.each @classes, (el, idx, arr)->
						$('.' + el).css('opacity', 1)

					e.off 'mouseleave'
					panel.on 'mouseover', fn

					d3.selectAll('.' + el)
						.transition()
						.delay(()->
							del = Math.random() * ts
							return del)
						.attr('r', (d)-> return d.scale)
						.style('z-index', 10)

				if el is s
					e.mouseleave _m
					panel.off 'mouseover'
					
					d3.selectAll('.' + el)
						.transition()
						.delay(()->
							del = Math.random() * ts
							return del)
						.attr('r', (d)-> return d.scale * ((Math.random() * 3) + 2))
						.style('z-index', 10000)

					_u = 1
				else
					_u = 0.3

				$('.' + el).css('opacity', _u)
			_.each @classes, _v

		panel.on 'mouseover', fn

	addListeners			:	()->
		EventManager.addListener Events.MAP_LOADED,					@onMapLoaded
		EventManager.addListener Events.SERVER_UPDATED,			@changeTitle
		EventManager.addListener Events.MAP_CLICKED,				@changeTitle
		EventManager.addListener Events.SOCKET_CONNECTED,		@onSocketConnected
		EventManager.addListener Events.FACEBOOK_LOGIN,			@onFacebookLogin
		EventManager.addListener Events.FACEBOOK_LOADED,		@onFacebookMarkersLoaded

		if Config.userType is 'user' then @addUserLocator()
		#$('#year-dropdown').on 'change', (e)->EventManager.emitEvent Events.ON_DATE_SELECT,[e.target.value]

	isSelectingLocation				:		false
	addUserLocator						:		()=>
		f = (event)=>
			@isSelectingLocation = true
			a = $ event.currentTarget
			a.addClass 'active'
			a.removeClass 'inactive'
			EventManager.emitEvent Events.USER_LOCATING, [event]
			
		userElement = $ '#marker-icon'
		userElement.on 'click', f

	onFacebookMarkersLoaded		:		(event)		=>
		@map.createPoints 'facebook', event.locations, 'blue'
		null
		
	onFacebookLogin		: (event)=>
		console.log 'facebook loaded'
		console.log event
		id  = event.location.id		

		src = Config.FACEBOOK.location

		uid = Math.random().toString(36).substr(2,9)

		fn = (d)=>
			key=
				id : event.id || uid()
				location:
					coords: [ d.location ]
					name	:		d.name

			@socket.socket.emit 'facebook', key
		
		d3.json src + id, fn

	onMapLoaded				:	()=>
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
		

