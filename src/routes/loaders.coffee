exports.loaders = (req, res) ->
	obj=
		title		:		'Loaders'
		amount	:		10

	res.render 'loaders', obj
