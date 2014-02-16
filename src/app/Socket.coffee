class SocketClient
	socket	:		null
	constructor							: (@host)->
		@createSocketConnection()

	createSocketConnection	:		()->
		@socket = io.connect @host
		@socket.name = Math.random().toString(36).substr(2,9)
		@addListeners()

	addListeners						:		()->
		@socket.on 'location', @onLocationHandler
		console.log @socket

	onLocationHandler				:		( data )=>
		console.log data



