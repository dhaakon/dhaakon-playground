class SocketServer
	io		: require		'socket.io'

	constructor				:		(@server, @http)->
		#console.log @http.get 'url'
		@createSocket()

	createSocket			:		()->
		@socket = @io.listen @server
		@addConnection()

	addConnection			:		()->
		@socket.sockets.on 'connection', @onConnectionHandler

	onConnectionHandler			:		(socket)=>
		#console.log @socket.sockets.sockets
		console.log socket
		socket.emit 'location', {lat: 0, long:200}
		
