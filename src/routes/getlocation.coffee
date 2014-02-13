#import geocoder.coffee

exports.getlocation		=		( req, res ) ->
	coords = [
		req.params['long'], req.params['lat']
	]

	l =
		coords	:		coords

	geo = new Geocoder()
	
	cb = (err, data) =>
		res.json data or err

	geo.getLocationByLatLong coords, cb
