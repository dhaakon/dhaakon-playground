class Map
	svg				:	null
	width			:	null
	height			:	null
	projection		:	null
	projector		:	d3.geo.equirectangular

	type			:	'places'

	constructor		:	(@src, @width, @height)->
		@createSVG()
		@readJSON()

	createSVG		:	()->
		@svg	=	d3.select('body')
					  .append('svg')
					  .attr('width', @width)
					  .attr('height', @height)
		 
	readJSON		:	()->
		d3.json		@src, @onDataRead

	onDataRead		:	( error, world )=>
		@places		=	topojson.feature(world, world.objects[@type])

		@projection =	@projector()
						.scale(300)
						.translate([@width / 2, @height / 2])

		@svg.append('path')
			.datum(@places)
			.attr('d', d3.geo.path().projection(@projection))
