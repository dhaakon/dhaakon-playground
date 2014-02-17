class SocketServer

	constructor				:		(@app)->
		@socket = @app
		@createSocket()

	createSocket			:		()->
		@socket.io.sockets.on 'connection', @onConnectionHandler
		@socket.io.sockets.on 'gps', @onGPSHandler

	createRoutes			:		()->
		@app.io.route('gps', (req)=>
			@socket.io.sockets.emit 'receiveResponse', req.data
		)

	onConnectionHandler			:		(socket)=>
		@createRoutes()
		socket.emit 'location', {lat:200, long:100}
		#socket.on 'gps', @onGPSHandler

	onGPSHandler			:		(event)->
		console.log event
		#@socket.emit 'receiveResponse', event

