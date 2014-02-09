routes		=	require		'./routes'
user		=	require		'./routes/user'
demos		=	require		'./routes/demos'
maps		=	require		'./routes/maps'
codem		=	require		'./routes/codem'
loaders		=	require		'./routes/loaders'

class Routes
	constructor		:	()->
		@routes		=	new Backbone.Collection()

r = new Routes()
