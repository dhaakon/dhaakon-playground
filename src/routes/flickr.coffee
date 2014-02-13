class Flickr
	api_key		:		'api_key':'7e6f810e37d4482c2da35dd883bbd7f6'
	flickr		:		require 'node-flickr'
	api				:		null

	constructor		:		()->
		@createFlickr()

	createFlickr	:		()->
		@api	=		new @flickr @api_key

	getPhotos			:		( page, cb )->
		photos		=		{}
		obj =
			user_id		:		'42877615@N04'
			tags			:		'wexplore'
			has_geo		:		'0'
			per_page	:		'500'
			page			:		page

		@api.get('photos.search', obj, cb)

	getLocations	:		( photos, cb)->
		maxPhotos		= 10
		i						=	0
		resp				=		[]
		photoLoaded	= (data)=>
			resp.push data

			obj =
				photo_id	:		photos.photo[++i].id
			if data.stat is 'fail'
				@api.get 'photos.geo.getLocation', obj, photoLoaded
			else
				cb data

		obj =
			photo_id	:		photos.photo[++i].id

		@api.get 'photos.geo.getLocation', obj, photoLoaded


