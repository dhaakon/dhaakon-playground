#import dependencies.coffee
#import redis.coffee
#import routes.coffee
#import socket_server.coffee

class Server
	express		:	require		'express.io'
	path			:	require		'path'

	app				:	null
	server		:	null

	routes		:	null
	redis			:	null

	constructor		:	()->
		@app	=	@express()
		@redis = new Redis()

		@setUpExpress()
		@createServer()

	setUpExpress	:	()->
		@app.set		'port'			,	process.env.PORT || 3000
		@app.set		'views'			,	@path.join(__dirname, 'views')
		@app.set		'view engine'	,	'jade'
		@app.set		'view options', pretty : true
	
		@app.use		@express.favicon()
		@app.use		@express.logger 'dev'
		@app.use		@express.json()
		@app.use		@express.urlencoded()
		@app.use		@express.methodOverride()
		@app.use		@app.router
		@app.use		@express.static @path.join(__dirname + '/', 'public')

	setUpRoutes		:	()->
		@app.get		'/',															Router.index
		@app.get		'/users',													Router.list
		@app.get		'/demos/:type',										Router.demos
		@app.get		'/maps/:renderer',								Router.map
		@app.get		'/codem',													Router.codem
		@app.get		'/loaders',												Router.loaders
		@app.get		'/tgsData',												Router.thinkData
		@app.get		'/tgs/:role',											Router.tgs
		@app.get		'/tgs-facebook/',									Router.facebook
		@app.get		'/location/:lat/:long',						Router.getlocation
		@app.get		'/students/',											Router.getstudents
		@app.get		'/faculty/',											Router.getfaculty
		@app.get		'/tgslocations/',									Router.tgslocations
		@app.get		'/tgs-dual/',											Router.dual

		if 'development' == @app.get 'env'
			@app.use @express.errorHandler()

	createServer	:	()->
		#@server = @http.createServer(@app)
		@app.http().io()
		
		@setUpRoutes()
		
		@socket = new SocketServer(@app, @redis)

		@app.listen( @app.get 'port' )


server = server or new Server()
