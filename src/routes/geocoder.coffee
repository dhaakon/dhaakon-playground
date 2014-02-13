class Geocoder
	api_key				:	'AIzaSyDn9BPGUMYumxXdTT_jSx4KL68jQZBlcKk'
	provider			:	'google'
	adapter				:	'http'
	geocoder			:	null

	constructor		:		()->
		@createGeocoder()
	
	createGeocoder	:		()->
		opts	=
			apiKey		:		@api_key
			formatter	:	null

		@geocoder = require('node-geocoder').getGeocoder(@provider, @adapter, opts)
	
	getLocation			:		( city, cb )->
		@geocoder.geocode city, cb
