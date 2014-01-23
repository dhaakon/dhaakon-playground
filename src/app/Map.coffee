class Map
	NEIGHBORS		:	'neighbors'
	COUNTRIES		:	'countries'

	projector		:	d3.geo
	color			:	d3.scale.category10()

	renderer		:	Config.Settings.renderer

	type			:	'countries'

	projectionType	:	Config.Map.projections[	Config.Map.projectionKey ]
	scale			:	Config.Map.scale
	xOffset			:	Config.Map.xOffset
	yOffset			:	Config.Map.yOffset
	scaleMin		:	Config.Map.scaleMin
	scaleMax		:	Config.Map.scaleMax

	t_lat_source		:	Config.Map.tour_lat_source
	t_lon_source		:	Config.Map.tour_lon_source
	b_lat_source		:	Config.Map.booker_lat_source
	b_lon_source		:	Config.Map.booker_lon_source

	markerSize		:	Config.Map.markerSize


	svg				:	null
	canvas			:	null
	group			:	null

	width			:	null
	height			:	null
	container		:	null
	projection		:	null

	data			:	null
	countries		:	null
	neighbors		:	null

	constructor		:	(@src, @width, @height, @container)->
		@addListeners()
		@createSVG()
		@createCanvas()
		@readJSON()

	addListeners	:	()->

	createSVG		:	()->
		@svg	=	d3.select(@container)
					  .append('svg')
					  .attr('id', 'svg-map')
					  .attr('width', @width)
					  .attr('height', @height)
					  
		@group	=	@svg.append('g')

	createCanvas	:	()->
		@canvas	=	d3.select(@container)
					  .append('canvas')
					  .attr('width', @width)
					  .attr('height', @height)
					  .attr('id', 'marker-canvas').call(d3.behavior.zoom().scaleExtent([@scaleMin,@scaleMax]).on('zoom', @zoomed))

		@context =	@canvas.node()
						   .getContext('2d')
		 
	readJSON		:	()->
		d3.json		@src, @onDataRead

	drawMap			:	()->
		@drawBackground()
		@drawGrid()
		@drawCountries()

		console.log 'drawing map'

	drawGrid		:	()->
		@group.append("path")
			.datum(d3.geo.graticule())
			.attr("d", @path)
			.style("fill", "none")
			.style("stroke", "#ffffff")
			.style("stroke-width", "0.5px")

	drawBackground	:	()->
		@group.append("path")
			.datum({type: "Sphere"})
			.attr("d", @path)
			.style("fill", "#93C2FF")

	createPoints	:	( @data )->
		console.log 'draw points'
		@drawPointsOnCanvas()

		return

		@group.selectAll('circle')
			.data(data)
			.enter()
			.append('circle')
			.attr('r', @markerSize )
			.attr('fill', 'rgba(150,0,0,0.4)')
			.attr('transform', (d)=>
				coords = @projection([d[@t_lon_source], d[@t_lat_source]])
				#coords = @projection([d[@b_lon_source], d[@b_lat_source]])
				return 'translate(' + coords + ')'
			)
			.on('mouseover', @onMarkerMouseOver)

	onMarkerMouseOver	:	(d)=>
		EventManager.emitEvent Events.MARKER_FOCUS, [d]

	fillNeighbors	:	(d, i)=>
		fn = (n) => return @countries[n].color
	
		r = (i - 50)
		b = i
		g = i	+	0
		a = 0.6
		
		colorString = 'rgba(' + [r,g,b,a].join(',') + ')'

		return colorString

	drawCountries	:	()->
		@group.selectAll('.country')
			.data(@countries)
			.enter().insert('path', '.graticule')
			.attr('class', 'country')
			.attr('d', @path)
			.style('fill', @fillNeighbors)
			.style('stroke', 'rgba(100,100,255,1)')

	onMouseMove				:	()->
		m = d3.mouse @
		
	onMouseWheel			:	(e)=>
		m = d3.event.wheelDeltaY

	zoomed			:	()=>
		@updateSVG(d3.event.translate, d3.event.scale)
		#@updateCanvas(d3.event.translate, d3.event.scale)


	updateSVG		:	( pos, scale)	=>
		_str	=	'translate(' +	pos.join(',') + ')scale(' + scale + ')'
		@group.attr('transform', _str)

	updateCanvas	:	( pos, scale)	=>
		_str	=	'translate(' +	pos.join(',') + ')scale(' + scale + ')'

		@context.save()
		@context.clearRect( 0, 0, @width, @height )
		@context.translate( pos[0], pos[1] )
		@context.scale(	scale[0], scale[1] )
		@drawPointsOnCanvas()
		@context.restore()

	createProjection	:	()=>
		@projection =	@projector[@projectionType]()
						.scale(@scale)
						.translate([(@width / 2) - @xOffset, (@height / 2) - @yOffset])

	createPath			:	()=>
		@path	=	d3.geo.path()
						  .projection(@projection)

	drawPointsOnCanvas :	()=>
		#return
		if not @data? then return

		i = -1
		n = @data.length - 1

		
		while ++i < n
			d = @data[i]
			p = @projection([d.tour_lat, d.tour_lon])
			#console.log p
			#@context.beginPath()
			#@context.moveTo p[0], p[1]
			#@canvas.fillRect( p[0], p[1], 10, 10)
			#@context.arc(	p[0], p[1], 5, 0, 2 * Math.PI		)
			#@context.closePath()
			#@context.fill()

		#@context.fill()


	update			:	()=>
		@drawMap()

	onDataRead		:	( error, world )=>
		@countries		=	topojson.feature(world, world.objects[@COUNTRIES]).features
		@neighbors		=	topojson.neighbors(world.objects[@COUNTRIES].geometries)

		@createProjection()
		@createPath()

		@drawMap()

		EventManager.emitEvent(Events.MAP_LOADED)
