class SocketClient
	socket	:		null
	constructor							: (@host, @type)->
		@createSocketConnection()

	createSocketConnection	:		()->
		opts =
			port : Config.port
		
		EventManager.addListener Events.MAP_LOADED, @onMapLoaded

		@socket = io.connect()
		@addListeners()

	addListeners						:		()->
		@socket.on 'connection', @onConnectionHandler
		@socket.on 'connect', @connect
		@socket.on 'data', @data
		@socket.on 'error', @error
	
	connect									:		(data)=>
		EventManager.emitEvent Events.SOCKET_CONNECTED

	data										:		(data)->
	error										:		(error)->

	onMapLoaded							:		(event)=>
		console.log 'map loaded'
		switch Config.userType
			when 'user'
				@socket.on 'location', @onLocationHandler

			when 'display'
				@socket.on 'receiveResponse', @onReceiveHandler
				@socket.on 'locationsLoaded', @onLocationsLoaded
				@socket.on 'facebookLoaded', @onFacebookLoaded
				@socket.emit 'serverStarted'

	onLocationHandler				:		( data )=>
		cb = (data) =>
			opts=
				location		:	
					title :		data.location
					coords	: [
						latitude		:	data.longitude
						longitude		:	data.latitude
					]
			@socket.emit 'gps', opts

		EventManager.addListener Events.MAP_CLICKED, cb

	onReceiveHandler				:		( data )=>
		EventManager.emitEvent Events.SERVER_UPDATED, [data]

	onConnectionHandler			:		( socket )=>
		null

	onFacebookLoaded	:		(data)=>
		console.log 'fb loaded'
		obj = JSON.parse JSON.parse data
		EventManager.emitEvent Events.FACEBOOK_LOADED, [obj]

	onLocationsLoaded				:		(data)=>
		console.log 'locations loaded'
		obj = JSON.parse JSON.parse data

		objects = []
		
		if obj?
			for loc of obj.locations
				_locs = JSON.parse obj.locations[loc]
				objects.push _locs

			EventManager.emitEvent Events.SERVER_STARTED, [objects]
		
		#console.log data



