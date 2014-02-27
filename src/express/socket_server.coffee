class SocketServer

	constructor				:		(@app, @redis)->
		@socket = @app
		@createSocket()

	createSocket			:		()->
		@socket.io.sockets.on 'connection', @onConnectionHandler

	createRoutes			:		()->
		@app.io.route('serverStarted', (req)=>
			@redis.client.get 'keys', (err, resp)=>
				obj = JSON.stringify resp		
				@socket.io.sockets.emit 'locationsLoaded', obj

			@redis.client.get 'facebook', (err, resp)=>
				obj = JSON.stringify resp		
				console.log 'facebookLoaded'
				console.log obj
				
				@socket.io.sockets.emit 'facebookLoaded', obj
		)

		@app.io.route('gps', (req)=>

			@socket.io.sockets.emit 'receiveResponse', req.data

			uid = Math.random().toString(36).substr(2,9)

			@redis.get
			
			@redis.client.get 'keys', (err, resp)=>
				obj = JSON.stringify req.data

				#keys = JSON.parse(resp) || {locations : []}
				keys = {locations : []}
				keys.locations.push obj

				@redis.client.set 'keys', JSON.stringify(keys)
			)

		@app.io.route('facebook', (req)=>
			@redis.client.get 'facebook', (err,resp)=>
				obj = req.data

				keys = {locations : []}
				console.log keys

				if keys
					for o of keys.locations
						a = keys.locations[o].id
						b = JSON.parse(obj).id
						
						if a is b then return

				keys.locations.push obj

				@redis.client.set 'facebook', JSON.stringify(keys)
		)

	onConnectionHandler			:		(socket)=>
		@createRoutes()
   
		socket.emit 'location'

	onGPSHandler			:		(event)->
		console.log event
		#@socket.emit 'receiveResponse', event

