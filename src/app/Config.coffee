Config	=	
	Settings	:
		jsonPath			:	'/json/world.json'
		csvPath				:	'/csv/booking_small.csv'
		renderer			:	'canvas'

	Map			:
		container			:	'#map-container'
		height				:	1200	
		width					:	1600	
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

	TGS			:
		src						:		'/tgsData/'
		students_src	:		'/students/'

