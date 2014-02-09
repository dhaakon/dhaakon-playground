#import dependencies.coffee
#import routes.coffee

class Server
	express		:	require		'express'
	http		:	require		'http'
	path		:	require		'path'

	app		:	null

	routes	:	null

	constructor		:	()->
		@app	=	@express()
		@setUpExpress()
		@setUpRoutes()
		@createServer()

	setUpExpress	:	()->
		@app.set		'port'			,	process.env.PORT || 3000
		@app.set		'views'			,	@path.join(__dirname, 'views')
		@app.set		'view engine'	,	'jade'
	
		@app.use		@express.favicon()
		@app.use		@express.logger 'dev'
		@app.use		@express.json()
		@app.use		@express.urlencoded()
		@app.use		@express.methodOverride()
		@app.use		@app.router
		@app.use		@express.static @path.join(__dirname, 'public')

	setUpRoutes		:	()->
		@app.get		'/'		,					routes.index
		@app.get		'/users',					user.list
		@app.get		'/demos/:type',				demos.demos
		@app.get		'/maps/:renderer',			maps.index
		@app.get		'/codem',			codem.codem
		@app.get		'/loaders',			loaders.loaders

		if 'development' == @app.get 'env'
			@app.use @express.errorHandler()

	createServer	:	()->
		@http.createServer(@app).listen(	@app.get('port'),
			()=>
				console.log 'Express server listening on port' + @app.get 'port'
		)

server = server or new Server()
