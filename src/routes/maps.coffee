exports.index	=	(req, res) ->
	renderer	=	req.params['renderer']

	options		=
		renderer	:	
			name		:	renderer
			isCanvas	:	renderer is 'canvas'
	
		title		:	renderer.toUpperCase() + ' Map'

	res.render 'maps', options
