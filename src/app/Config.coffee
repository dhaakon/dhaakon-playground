Config	=	window.Config =
	Graphics:
		Colors:
			location : 'red'
			grade:
				9		:	'blue'
				10	:	'orange'
				11	:	'orange'
				12	:	'brown'
			faculty : 'yellow'

	display :
		Settings	:
			jsonPath			:	'/json/world.json'
			csvPath				:	'/csv/booking_small.csv'
			renderer			:	'canvas'
			hasGrid				:	false
			hasRotation		:	false
			hasLines			:	false

		Map			:
			container			:	'#map-container'
			height				:	null	
			width					:	null	
			scale					:	350
			xOffset				:	0
			yOffset				:	0

			scaleMin			:	0.75
			scaleMax			:	10

			projections	:	[	
										'stereographic',				# 0
										'orthographic',					# 1
										'mercator',							# 2
										'gnomonic',							# 3
										'equirectangular',			# 4
										'conicEquidistant',			# 5
										'conicConformal',				# 6
										'conicEqualArea',				# 7
										'azimuthalEquidistant',	# 8
										'azimuthalEqualArea',		# 9
										'albersUsa',						# 10
										'transverseMercator'		# 11
										]

			projectionKey		:	4
			markerSize			:	2
			rotation				:	[ 0, -15 ]
			velocity				:	20

	user :
		Settings	:
			jsonPath			:	'/json/world.json'
			csvPath				:	'/csv/booking_small.csv'
			renderer			:	'canvas'
			hasGrid				:	false
			hasRotation		:	false
			hasLines			: false	

		Map			:
			container			:	'#map-container'
			height				:	null
			width					:	null	
			scale					:	350
			xOffset				:	0
			yOffset				:	0

			scaleMin			:	0.75
			scaleMax			:	10

			projections	:	[	
										'stereographic',				# 0
										'orthographic',					# 1
										'mercator',							# 2
										'gnomonic',							# 3
										'equirectangular',			# 4
										'conicEquidistant',			# 5
										'conicConformal',				# 6
										'conicEqualArea',				# 7
										'azimuthalEquidistant',	# 8
										'azimuthalEqualArea',		# 9
										'albersUsa',						# 10
										'transverseMercator'		# 11
										]

			projectionKey		:	4
			markerSize			:	2
			rotation				:	[ 0, -15 ]
			velocity				:	20



	TGS			:
		src						:		'/tgslocations/'
		students_src	:		'/students/'
		faculty_src		:		'/faculty/'

	FACEBOOK	:	
		location	:		'http://graph.facebook.com/'
