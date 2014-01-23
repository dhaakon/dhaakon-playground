Config	=	
	Settings	:
		jsonPath		:	'/json/world.json'
		csvPath			:	'/csv/booking_small.csv'
		renderer		:	'canvas'
	Map		:
		container		:	'#map-container'
		height			:	768	
		width			:	1224	
		scale			:	500
		xOffset			:	0
		yOffset			:	-230

		scaleMin		:	0.75
		scaleMax		:	10

		projections		:	[	
								'stereographic',		# 0
								'orthographic',			# 1
								'mercator',				# 2
								'gnomonic',				# 3
								'equirectangular',		# 4
								'conicEquidistant',		# 5
								'conicConformal',		# 6
								'conicEqualArea',		# 7
								'azimuthalEquidistant',	# 8
								'azimuthalEqualArea',	# 9
								'albersUsa',			# 10
								'transverseMercator'	# 11
							]

		projectionKey	:	2
		markerSize		:	0.5

		booker_lat_source		:	'booker_lat'
		booker_lon_source		:	'booker_lon'
		tour_lat_source			:	'tour_lat'
		tour_lon_source			:	'tour_lon'
