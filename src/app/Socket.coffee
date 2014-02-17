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
		opts	=		'transports': ['xhr-polling']
		@socket = io.connect(url, opts)
		@addListeners()

	addListeners						:		()->
		switch @type
			when 'user'
				@socket.on 'location', @onLocationHandler
				@socket.on 'receiveResponse',  @onReceiveHandler

			when 'server'
				@socket.on 'receiveResponse', @onReceiveHandler

		@socket.on 'connection', @onConnectionHandler
		@socket.on 'connect', @connect
		@socket.on 'data', @data
		@socket.on 'error', @error

	connect									:		(data)->
		console.info('Successfully established a working connection');

	data										:		(data)->
		console.log data

	error										:		(error)->
		console.log error

	onLocationHandler				:		( data )=>
		i=0
		cb = (event) =>
			console.log 'touch'
			@socket.emit 'gps', {a:++i}

		$(window).on 'click', cb
		$(window).on 'touchstart', cb

		console.info 'Received location event'
		console.log data

	onReceiveHandler				:		( data )=>
		console.log data

	onConnectionHandler			:		( socket )=>
		console.log socket




