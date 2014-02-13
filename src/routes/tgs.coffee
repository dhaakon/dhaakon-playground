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

	filename = '../json/tgs.json'

	obj					=	{}
	obj.flickr	=	f

	pages	=	7
	i			=	1

	photos	= {}
	citycount = 0

	#photos = JSON.parse data
	fs.readFile filename, (_data)->res.json _data	

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
					#console.log photoArray[photoCount].location.title
					#console.log correctNames[photoArray[photoCount].location.title]
					geo.getLocation correctNames[photoArray[photoCount].location.title], fn
					return

				if photoCount > 0
					photoCount--
					geo.getLocation photoArray[photoCount].location.title, fn
				else
					res.json photoArray
					_json = JSON.stringify photoArray

					fs.writeFile '.' + filename, _json, (err)-> if err? then console.log err else console.log 'saved'

			geo.getLocation photoArray[--photoCount].location.title, fn
		else
			f.getPhotos( i, cb )

	f.getPhotos( i, cb )

exports.tgs		=		( req, res ) ->
	res.render 'tgs'

