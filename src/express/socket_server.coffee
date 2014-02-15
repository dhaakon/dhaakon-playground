class SocketServer
	io		: require		'socket.io'

	constructor				:		(@app)->
		@createSocket()

	createSocket			:		()->
		@socket = @io.listen @app
		@addConnection()

	addConnection			:		()->
		@socket.sockets.on 'connection', @onConnectionHandler

	onConnectionHandler			:		(socket)=>
		#console.log socket
		socket.emit 'location', {lat: 0, long:200}
		
