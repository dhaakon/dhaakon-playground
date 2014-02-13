class Map

	NEIGHBORS				:	'neighbors'
	COUNTRIES				:	'countries'

	projector				:	d3.geo
	color						:	d3.scale.category10()

	renderer				:	Config.Settings.renderer

	type						:	'countries'
	projectionType	:	Config.Map.projections[	Config.Map.projectionKey ]

	scale						:	Config.Map.scale
	xOffset					:	Config.Map.xOffset
	yOffset					:	Config.Map.yOffset
	scaleMin				:	Config.Map.scaleMin
	scaleMax				:	Config.Map.scaleMax

	t_lat_source		:	Config.Map.tour_lat_source
	t_lon_source		:	Config.Map.tour_lon_source
	b_lat_source		:	Config.Map.booker_lat_source
	b_lon_source		:	Config.Map.booker_lon_source

	markerSize			:	Config.Map.markerSize
	svg							:	null
	canvas					:	null
	group						:	null

	width						:	null
	height					:	null
	container				:	null
	projection			:	null

	data						:	null
	countries				:	null
	neighbors				:	null

	constructor		:	(@src, @width, @height, @container)->

		if @renderer is 'canvas'
			@createCanvas()
		else
			@createSVG()

		@readJSON()
		@addListeners()

	addListeners	:	()->


	createSVG		:	()->
		@svg	=	d3.select(@container)
						  .append('svg')
						  .attr('id', 'svg-map')
						  .attr('width', @width)
						  .attr('height', @height)
						  .on('mousedown', @onMouseDownHandler)
					  
		@group	=	@svg.append('g')

	createCanvas	:	()->
		@canvas	=	d3.select(@container)
							  .append('canvas')
							  .attr('width', @width)
							  .attr('height', @height)
							  .attr('id', 'marker-canvas').call(d3.behavior.zoom().scaleExtent([@scaleMin,@scaleMax]).on('zoom', @zoomed))

		@context =	@canvas.node().getContext('2d')
		 
	readJSON		:	()->
		d3.json		@src, @onDataRead

	drawMap			:	()->
		@drawBackground()
		@drawGrid()
		@drawCountries()

	drawGrid		:	()->
		switch @renderer
			when 'svg'
				@group.append("path")
							.datum(d3.geo.graticule())
							.attr("d", @path)
							.style("fill", "none")
							.style("stroke", "#ffffff")
							.style("stroke-width", "0.5px")

	drawBackground	:	()->
		switch @renderer
			when 'svg'
				@group.append("path")
					.datum({type: "Sphere"})
					.attr("d", @path)
					.style("fill", "#93C2FF")

	createPoints	:	( @data )->
		switch @renderer
			when 'svg'
				@group.selectAll('circle')
					.data(@data)
					.enter()
					.append('circle')
					.attr('r', @markerSize )
					.attr('fill', 'rgba(150,0,0,0.4)')
					.attr('transform', (d)=>
						_d = d.location.coords[0]
						#coords = @projection([d[@t_lon_source], d[@t_lat_source]])
						#coords = @projection([d[@b_lon_source], d[@b_lat_source]])
						coords = @projection([_d['longitude'], _d['latitude']])
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
		switch @renderer
			when 'svg'
				@group.selectAll('.country')
					.data(@countries)
					.enter().insert('path', '.graticule')
					.attr('class', 'country')
					.attr('d', @path)
					.style('fill', @fillNeighbors)
					.style('stroke', 'rgba(100,100,255,1)')
			when 'canvas'
				@context.fillStyle = '#d7c7ad'
				@context.beginPath()
				@path(@neighbors)
				@context.fill()
				@path(@countries)
				@context.stroke()

	onMouseMove				:	()->
		m = d3.mouse @
		
	onMouseWheel			:	(e)=>
		m = d3.event.wheelDeltaY

	onMouseDownHandler	:		()=>
		m = d3.event
		coords = [m['offsetX'], m['offsetY']]

		geo_loc = @projection.invert(coords)

		str = '/location/' + geo_loc.join('/') + '/'

		cb = (data) =>
			if data[0]?
				country		=	data[0].country
				city			=	data[0].city
				state			=	data[0].state

				loc = [country, city, state].join(', ')

		#d3.json str, cb

		@group.append('circle')
				.attr('r', @markerSize - 3 )
				.attr('fill', 'rgba(150,100,0,0.8)')
				.attr('transform', (d)=>
						coords = @projection(geo_loc)
						return 'translate(' + coords.join(',') + ')'
				)

	zoomed			:	()=>
		@updateSVG(d3.event.translate, d3.event.scale)

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
		switch @renderer
			when 'canvas'
				@path	=	d3.geo.path()
								  .projection(@projection)
									.context(@context)

			when 'svg'
				@path = d3.geo.path()
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
