#import flickr.coffee
#import geocoder.coffee

exports.thinkData = ( req, res )->
	fs	= require 'fs'
	_		= require 'underscore'

	correctNames =
		'Ringha Village, China'							: 'Deqin, China',
		'Ringha Village, Tibet'							: 'Deqin, China',
		'Garmisch-Partinkirchen, Germany'		:	'Garmisch-Partenkirchen, Germany'
		'Kleinmachnow, Germany'							:	'Dahlem, Germany'
		'Karlsruhe, Germany'								:	'Durlach, Germany'
		'Thimphu, Bhutan'										:	'Paro, Bhutan'
		'Osorakan Park, Japan'							:	'Hiroshima, Japan'
		'Donsao, Laos'											:	'Nong Ruea Sao, Thailand'
		'Punahka, Bhutan'										:	'Paro, Bhutan'
		'Colonia, Uruguay'									:	'Colonia del Sacramento, Uruguay'

	f		= new Flickr()
	geo =	new Geocoder()

	filename = 'public/json/tgs.json'

	obj					=	{}
	obj.flickr	=	f

	pages	=	7
	i			=	1

	photos	= {}
	citycount = 0

	fs.readFile filename,'utf-8', (err, _data)-> 
		_d = eval _data

		for obj in _d
			delete obj['photos']

		res.send _d	
		#fs.writeFile 'public/json/tgs-no-photos.json'

	return

	cb = (data)=>
		for photo of data.photos.photo
			_photo		=	data.photos.photo[photo]
			city			=	_photo.title.split('(')[1]

			if city?
				++citycount
				city = city.substring(0, city.length-1)
				if city.split(',').length > 1
					if photos[city]?
						photos[city].photos.push _photo
					else
						photos[city] =
							photos			:	[_photo]
							location		:
								title			:	city
								coords		:	[]

		if  ++i > pages
			photoArray = _.toArray(photos)
			photoCount = photoArray.length

			fn = (err, resp)=>
				if resp?
					photoArray[photoCount].location.title
					for property in resp
						photoArray[photoCount].location.coords.push property
				else
					geo.getLocationByCityName correctNames[photoArray[photoCount].location.title], fn
					return

				if photoCount > 0
					photoCount--
					geo.getLocationByCityName photoArray[photoCount].location.title, fn
				else
					res.json photoArray
					_json = JSON.stringify photoArray

					fs.writeFile '.' + filename, _json, (err)-> if err? then console.log err else console.log 'saved'

			geo.getLocationByCityName photoArray[--photoCount].location.title, fn
		else
			f.getPhotos( i, cb )

	f.getPhotos( i, cb )

exports.tgs		=		( req, res ) ->
	urlOption = req.originalUrl.split('?')[1]
	urlOptions = urlOption.split('&')
	
	params = {}

	for opt in urlOptions
		arr			=		opt.split('=')
		key			=		arr[0]
		value		=		arr[1]
		params[key] = value

	console.log params

	opts =
		renderer					:		req.params['renderer']
		scale							:		req.params['scale']
		projectionKey			:		req.params['projectionKey']
		amount						:		10
		role							:		req.params['role']
		params						:		params

	res.render 'tgs', opts

exports.getstudents		=		( req, res)->
	csv = require 'fast-csv'
	fs  = require 'fs'
	_		=	require 'underscore'

	_path = 'public/csv/students.csv'

	_stream = fs.createReadStream _path
	i = 0
	opts = {}
	students = []

	filename = 'public/json/students.json'
	fs.readFile filename,'utf-8',
		(err, _data)->
			_d = eval _data

			res.send _d

	return

	geo = new Geocoder()

	cb = (data) =>
		if i == 0
			for prop in data
				opts[prop] = ''
			++i
		else
			obj = {}
			o = 0
			for property of opts
				obj[property] = data[o]
				++o
			students.push obj
			++i

	onEnd	= () =>
		l = students.length
		
		fn = (err, data)=>
			console.log err, data
			if !err
				if l >= 0
					student = students[l]
					loc = student.City + ', ' + student.Country
					console.log loc
					opts =
						location :
							coords	:		[data[0]]
					_.extend students[l], opts
					geo.getLocationByCityName loc, fn
					--l
				else
					fs.writeFile 'public/json/students.json', JSON.stringify students
					res.json students
		
		student = students[--l]
		loc = student.City + ', ' + student.Country
		console.log loc
		geo.getLocationByCityName loc, fn
		#console.log c

	c = csv(_stream)
			.on('data', cb )
			.on('end', onEnd)
			.parse()
	
	
	return

exports.tgslocations		=		( req, res)->
	csv = require 'fast-csv'
	fs  = require 'fs'
	_		=	require 'underscore'

	_path = 'public/csv/tgs_countries.csv'

	_stream = fs.createReadStream _path
	i = 0
	opts = {}
	students = []

	filename = 'public/json/students.json'
	fs.readFile filename,'utf-8',
		(err, _data)->
			_d = eval _data

			res.send _d

	return

	geo = new Geocoder()

	cb = (data) =>
		if i == 0
			for prop in data
				opts[prop] = ''
			++i
		else
			obj = {}
			o = 0
			for property of opts
				obj[property] = data[o]
				++o
			students.push obj
			++i

	onEnd	= () =>
		l = students.length
		
		fn = (err, data)=>
			console.log err, data
			if !err
				if l >= 0
					student = students[l]
					loc = student.City + ', ' + student.Country
					console.log loc
					opts =
						location :
							coords	:		[data[0]]
					_.extend students[l], opts
					geo.getLocationByCityName loc, fn
					--l
				else
					fs.writeFile 'public/json/students.json', JSON.stringify students
					res.json students
		
		student = students[--l]
		loc = student.City + ', ' + student.Country
		console.log loc
		geo.getLocationByCityName loc, fn
		#console.log c

	c = csv(_stream)
			.on('data', cb )
			.on('end', onEnd)
			.parse()
	
	
	return
