exports.index	=	(req, res) ->
	obj =
		title	:	'd3 ——  Data Visualization'

	res.render 'index', obj

exports.worldjson = (req, res)->
	fs  = require 'fs'
	filename = 'public/json/world.json'

	fs.readFile filename,'utf-8',
		(err, _data)->
			_d = eval _data

			res.send _d
