class Map

	NEIGHBORS				:	'neighbors'
	COUNTRIES				:	'countries'

	projector				:	d3.geo
	color						:	d3.scale.category10()

	renderer				:	null

	type						:	'countries'
	projectionType	:	Config.Map.projections[	Config.Map.projectionKey ]

	scale						:	null
	xOffset					:	Config.Map.xOffset
	yOffset					:	Config.Map.yOffset
	scaleMin				:	Config.Map.scaleMin
	scaleMax				:	Config.Map.scaleMax

	markerSize			:	Config.Map.markerSize
	svg							:	null
	canvas					:	null
	group						:	null

	width						:	null
	height					:	null
	container				:	null
	projection			:	null

	students				:	null
	flickr					:	null

	data						:	null
	countries				:	null
	neighbors				:	null

	constructor		:	(@src, @width, @height, @container, @renderer, @scale)->
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
							
					  
		@group	=	@svg.append('g')
									#.on('mousedown', @onMouseDownHandler)
									.call(d3.behavior.zoom().scaleExtent([1, 8]).on("zoom", @zoomed))


	createCanvas	:	()->
		@canvas	=	d3.select(@container)
							  .append('canvas')
							  .attr('width', @width)
							  .attr('height', @height)
							  .attr('id', 'marker-canvas')#.call(d3.behavior.zoom().scaleExtent([@scaleMin,@scaleMax]).on('zoom', @zoomed))

		@context =	@canvas.node().getContext('2d')
		 
	readJSON		:	()->
		d3.json		@src, @onDataRead

	drawMap			:	()->
		#@drawBackground()
		#@drawGrid()
		@drawCountries()

	drawGrid		:	()->
		switch @renderer
			when 'svg'
				@group.append("path")
							.datum(d3.geo.graticule())
							.attr("d", @path)
							#.style("fill", "")
							.style("stroke", "#ffffff")
							.style("stroke-width", "0.5px")

	drawBackground	:	()->
		switch @renderer
			when 'svg'
				@group.append("defs").append("path")
					.datum({type: "Sphere"})
					.attr('id','sphere')
					.attr("d", @path)
					.style("fill", "white")

				@group.append("use")
						.attr("class", "stroke")
						.attr("xlink:href", "#sphere")

				@group.append("use")
						.attr("class", "fill")
						.attr("xlink:href", "#sphere")

	createPoints	:	( name, data, color )->
		@[name] = data
		switch @renderer
			when 'svg'
				@group.selectAll('group')
					.data(@[name])
					.enter()
					.append('circle')
					.attr('r', @markerSize * 2 )
					.attr('fill', color)
					.attr('transform', (d)=>
						_d = d.location.coords[0]
						coords = @projection([_d['longitude'], _d['latitude']])
						return 'translate(' + coords + ')'
					)
					.on('mouseover', @onMarkerMouseOver)
			when 'canvas'
				console.log 'drawing'
				createPoint = (d) =>
					#return
					fn = (el, idx, array) =>
						_d = el.__data__.location.coords[0]
						coords = @projection([_d['longitude'], _d['latitude']])
						size = @markerSize*2
						@context.fillStyle = color
						@context.fillRect(coords[0], coords[1],size, size)


					d[0].forEach(fn)
					#_d = d.location.coords[0]

				console.log @[name]
				return
				@canvas.selectAll('canvas')
					 .data(@[name])
					 .enter()
					 .call(createPoint)

	drawLines				  : (src)->
		return
		for path in @[src[0]]
			coords = @projection([ path.location.coords[0]['longitude'], path.location.coords[0]['latitude']])
			@group.selectAll('group')
							.data(@[src[1]])
							.enter()
							.append('path')
							.attr('d', (d)=>
								_d = d.location.coords[0] 

								m = 'M' + coords.join(' ')
								l = 'L' + @projection([_d['longitude'], _d['latitude']]).join(' ')

								return [m,l].join(' ')
							)
							.attr('stroke','rgba(0,0,250,0.1)')
							.attr('stroke-width', '1')
							.attr('fill','none')

	onMarkerMouseOver	:	(d)=>
		EventManager.emitEvent Events.MARKER_FOCUS, [d]

	fillNeighbors	:	(d, i)=>
		fn = (n) => return @countries[n].color
	
		r = (i - 50)
		b = i
		g = i	+	0
		a = 0.6

		colorString = 'rgba(' + [r,g,b,a].join(',') + ')'

		return 'rgba(225,225,255,0.8)' #colorString

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
				@path(@countries)
				@context.fill()
				@path(@neigbors)
				@context.stroke()

	onMouseMove				:	()->
		m = d3.mouse @
		
	onMouseWheel			:	(e)=>
		m = d3.event.wheelDeltaY

	onMouseDownHandler	:		()=>
		return #for now

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

		c = @group.append('circle')
					.attr('r', @markerSize )
					.attr('fill', 'rgba(150,100,0,0.8)')
					.attr('transform', (d)=>
							return 'translate(' + coords.join(',') + ')'
					)

		l = @group.selectAll('group')
				.data(@data)
				.enter()
				.append('path')
				.attr('d', (d)=>
					_d = d.location.coords[0] || d.location

					m = 'M' + coords.join(' ')
					l = 'L' + @projection([_d['longitude'], _d['latitude']]).join(' ')

					return [m,l].join(' ')
				)
				.attr('stroke','rgba(0,0,250,0.2)')
				.attr('stroke-width', '1')
				.attr('fill','none')

	zoomed			:	()=>
		@updateSVG(d3.event.translate, d3.event.scale)

	updateSVG		:	( pos, scale)	=>
		_str	=	'matrix('+scale+',0,0,'+scale+',' +	pos.join(',') + ')'
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
						.clipAngle(90)
						.precision(.5);

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
		if @renderer is 'canvas'
			@countries		=	topojson.feature(world, world.objects[@COUNTRIES])
		else
			@countries		=	topojson.feature(world, world.objects[@COUNTRIES]).features

		@neighbors		=	topojson.neighbors(world.objects[@COUNTRIES].geometries)

		@createProjection()
		@createPath()

		@drawMap()

		EventManager.emitEvent(Events.MAP_LOADED)
