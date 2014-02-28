class SocketClient
	socket	:		null
	constructor							: (@host, @type, @isFacebook)->
		@createSocketConnection()

	createSocketConnection	:		()->
		opts =
			port : Config.port
		
		EventManager.addListener Events.MAP_LOADED, @onMapLoaded

		if @isFacebook is false
			@socket = io.connect()
			@addListeners()
		else
			EventManager.emitEvent Events.SOCKET_CONNECTED

	addListeners						:		()->
		switch Config.userType
			when 'user'
				@socket.on 'location', @onLocationHandler
			when 'facebook'
				@socket.on 'location', @onLocationHandler

		@socket.on 'connection', @onConnectionHandler
		@socket.on 'connect', @connect
		@socket.on 'data', @data
		@socket.on 'error', @error
	
	connect									:		(data)=>
		EventManager.emitEvent Events.SOCKET_CONNECTED

	data										:		(data)->
	error										:		(error)->

	onMapLoaded							:		(event)=>
		#console.log Config.isFacebook
		#console.log Config
		if Config.isFacebook then return
		switch Config.userType
			when 'display'
				@socket.on 'receiveResponse', @onReceiveHandler
				@socket.on 'locationsLoaded', @onLocationsLoaded
				@socket.on 'facebookLoaded', @onFacebookLoaded
				@socket.emit 'serverStarted'

	onLocationHandler				:		( data )=>
		cb = (data) =>
			opts=
				location		:	
					title		:		data.location
					coords	:		[
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
		obj = JSON.parse JSON.parse data
		EventManager.emitEvent Events.FACEBOOK_LOADED, [obj]

	onLocationsLoaded				:		(data)=>
		obj = JSON.parse JSON.parse data

		objects = []
		
		if obj?
			for loc of obj.locations
				_locs = JSON.parse obj.locations[loc]
				objects.push _locs

			EventManager.emitEvent Events.SERVER_STARTED, [objects]
