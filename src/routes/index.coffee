exports.index	=	(req, res) ->
	obj =
		title	:	'd3 ——  Data Visualization'

	res.render 'index', obj
