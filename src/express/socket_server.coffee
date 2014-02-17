class SocketServer

	constructor				:		(@app, @redis)->
		@socket = @app
		@createSocket()

	createSocket			:		()->
		@socket.io.sockets.on 'connection', @onConnectionHandler
		@socket.io.sockets.on 'gps', @onGPSHandler

	createRoutes			:		()->
		@app.io.route('serverStarted', (req)=>
			@redis.client.get 'keys', (err, resp)=>
				obj = JSON.stringify resp
				console.log 'keys got'
				@socket.io.sockets.emit 'locationsLoaded', obj
		)

		@app.io.route('gps', (req)=>
			@socket.io.sockets.emit 'receiveResponse', req.data
			console.log req.data.location

			uid = Math.random().toString(36).substr(2,9)

			@redis.get
			
			@redis.client.get 'keys', (err, resp)=>
				obj = JSON.stringify req.data

				keys = JSON.parse(resp) || {locations : []}
				keys.locations.push obj

				@redis.client.set 'keys', JSON.stringify(keys)
			)
			#@redis.client.get 'keys', (err,c)=>console.log c


	onConnectionHandler			:		(socket)=>
		@createRoutes()

		socket.emit 'location'

	onGPSHandler			:		(event)->
		console.log event
		#@socket.emit 'receiveResponse', event

