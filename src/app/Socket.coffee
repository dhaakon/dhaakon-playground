class SocketClient
	socket	:		null
	constructor							: (@host)->
		@createSocketConnection()

	createSocketConnection	:		()->
		@socket = io.connect @host
		@addListeners()

	addListeners						:		()->
		@socket.on 'location', @onLocationHandler
		console.log @socket

	onLocationHandler				:		( data )=>
		console.log data



