class SocketClient
	socket	:		null
	constructor							: (@host, @type)->
		@createSocketConnection()

	createSocketConnection	:		()->
		opts =
			port : Config.port

		console.log location.origin
		url = location.origin
		#url += @host.substring(0, @host.length-1)
		#url += ':' + opts.port
		#opts	=		'transports': ['xhr-polling']
		@socket = io.connect()
		@addListeners()

	addListeners						:		()->
		switch @type
			when 'user'
				@socket.on 'location', @onLocationHandler
				#@socket.on 'receiveResponse',  @onReceiveHandler

			when 'server'
				@socket.on 'receiveResponse', @onReceiveHandler
				@socket.on 'locationsLoaded', @onLocationsLoaded
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
			console.log opts

			@socket.emit 'gps', opts
		EventManager.addListener Events.MAP_CLICKED, cb

		console.info 'Received location event'

	onReceiveHandler				:		( data )=>
		EventManager.emitEvent Events.SERVER_UPDATED, [data]

	onConnectionHandler			:		( socket )=>
		console.log socket

	onLocationsLoaded				:		(data)=>
		obj = JSON.parse JSON.parse data
		objects = []
		if obj?
			for loc of obj.locations
				_locs = JSON.parse obj.locations[loc]
				objects.push _locs
			EventManager.emitEvent Events.SERVER_STARTED, [objects]
		
		#console.log data



