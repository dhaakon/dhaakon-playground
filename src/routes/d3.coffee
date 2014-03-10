exports.d3 = (req, res)->
	obj =
		type	:		req.params['type']

	res.render 'd3', obj
