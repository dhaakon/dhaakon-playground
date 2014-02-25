class SocketClient
	socket	:		null
	constructor							: (@host, @type)->
		@createSocketConnection()

	createSocketConnection	:		()->
		opts =
			port : Config.port

		@socket = io.connect()
		@addListeners()

	addListeners						:		()->
		switch @type
			when 'user'
				@socket.on 'location', @onLocationHandler
				#@socket.on 'receiveResponse',  @onReceiveHandler

			when 'display'
				@socket.on 'receiveResponse', @onReceiveHandler
				@socket.on 'locationsLoaded', @onLocationsLoaded
				@socket.on 'facebookLoaded', @onFacebookLoaded
				@socket.emit 'serverStarted'
 
		@socket.on 'connection', @onConnectionHandler
		@socket.on 'connect', @connect
		@socket.on 'data', @data
		@socket.on 'error', @error

	connect									:		(data)->
		console.info('Successfully established a working connection');
		EventManager.emitEvent Events.SOCKET_CONNECTED

	data										:		(data)->
		console.log data

	error										:		(error)->
		console.log error

	onLocationHandler				:		( data )=>
		cb = (data) =>
			opts=
				location		:	
					title :		data.location
					coords	: [
						latitude		:	data.longitude
						longitude		:	data.latitude
					]
			#@socket.emit 'gps', opts

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
		
		#console.log data



