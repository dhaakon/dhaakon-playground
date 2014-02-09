exports.demos	=	(req, res)	->
	demoType	=	req.params['type']

	obj		=	
		title	=	demoType

	res.render	'demos/' + demoType, obj
