class Map
	NEIGHBORS				:	'neighbors'
	COUNTRIES				:	'countries'

	projector				:	d3.geo
	color						:	d3.scale.category10()

	renderer				:	null

	type						:	'countries'
	projectionType	: null	

	scale						:	null
	xOffset					: null
	yOffset					:	null
	scaleMin				:	null
	scaleMax				:	null

	markerSize			:	null
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
	hasGrid					:	false
	arc							:	-100

	startRotation		:	[ 0, -15 ]

	constructor		:	(@src, @width, @height, @container, @renderer, @scale, @projectionKey, @hasGrid, @startRotation)->
		@projectionType = Config[Config.userType].Map.projections[	@projectionKey ]
		@loadFromConfig()

		if @renderer is 'canvas'
			@createCanvas()
		else
			@createSVG()

		@readJSON()
		@addListeners()

	loadFromConfig	:		() ->
		@xOffset					=	Config[Config.userType].Map.xOffset
		@yOffset					=	Config[Config.userType].Map.yOffset
		@scaleMin					=	Config[Config.userType].Map.scaleMin
		@scaleMax					=	Config[Config.userType].Map.scaleMax
		@markerSize				=	Config[Config.userType].Map.markerSize

	addListeners	:	()->
		EventManager.addListener Events.SERVER_UPDATED, @onServerUpdated
		EventManager.addListener Events.SERVER_STARTED, @onServerStarted

	createSVG		:	()->
		@svg	=	d3.select(@container)
						  .append('svg')
						  .attr('id', 'svg-map')
						  .attr('width', @width)
						  .attr('height', @height)
							
					  
		@group	=	@svg.append('g')
									.on('mousedown', @onMouseDownHandler)
									.call(d3.behavior.zoom().scaleExtent([1, 8]).on("zoom", @zoomed))


	createCanvas	:	()->
		@canvas	=	d3.select(@container)
							  .append('canvas')
							  .attr('width', @width)
							  .attr('height', @height)
							  .attr('id', 'marker-canvas')
								.on('click', @onMouseDownHandler)
								#.call(d3.behavior.zoom().scaleExtent([@scaleMin,@scaleMax]).on('zoom', @zoomed))

		@context =	@canvas.node().getContext('2d')
		 
	readJSON		:	()->
		d3.json		@src, @onDataRead

	drawMap			:	()->
		@drawBackground()
		if @hasGrid then @drawGrid()
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
			when 'canvas'
				@context.strokeStyle = 'white'
				@context.beginPath()
				@path(d3.geo.graticule()())
				@context.stroke()

	onServerUpdated		: (event)=>
		#console.log @flickr[0], event
		@flickr.push event

		@drawBackground()
		if @hasGrid then @drawGrid()
		@drawCountries()
		@drawLines(@lines)

		@createPoints 'flickr', @flickr, 'red'
		@createPoints 'students', @students, 'blue'

	onServerStarted		: (event)=>
		#console.log @flickr[0], event
		#console.log event.location
		for loc in event
			if loc?
				console.log loc
				#console.log event.location[loc]
				@flickr.push loc

		@drawBackground()
		if @hasGrid then @drawGrid()
		@drawCountries()
		@drawLines(@lines)

		@createPoints 'flickr', @flickr, 'red'
		@createPoints 'students', @students, 'blue'


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

			when 'canvas'
				rgba = [		0,
										40,
										5,
										1
								]
				str = 'rgba(' + rgba.join(',') + ')'
				console.log str
				@context.fillStyle = str
				@context.fillRect( 0, 0, @width, @height)

	createPoint : (d) =>
		fn = (el, idx, array) =>
			_d = el.__data__.location.coords[0]
			coords = @projection([_d['longitude'], _d['latitude']])
			size = @markerSize*2
			@context.fillStyle = @color
			@context.fillRect(coords[0], coords[1],size, size)

		d[0].forEach(fn)

	createPoints	:	( name, data, @color )->
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
				#return
				#return
				@canvas.select('canvas')
					 .data(@[name])
					 .enter()
					 .call(@createPoint)
					 #.exit()

	drawLines				  : (@lines)->
		#if @renderer is 'canvas' then return

		for path in @[@lines[0]]
			coords = @projection([ path.location.coords[0]['longitude'], path.location.coords[0]['latitude']])

			switch @renderer
				when 'svg'
					@group.selectAll('group')
									.data(@[@lines[1]])
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

				when 'canvas'
					fn = (d)=>
						_f = (el, index, array) =>
							aCoords = [
													el.__data__.location.coords[0].longitude,
													el.__data__.location.coords[0].latitude
												]
							l1 = @projection aCoords

							cb = (d)=>
								_g = (el, index, array)=>
									bCoords = [
															el.__data__.location.coords[0].longitude,
															el.__data__.location.coords[0].latitude
														]
									
									l2 = @projection bCoords

									op		=	0.15
									colA	= [ 255, 255, 0,	op]
									colB	= [ 255, 0,	 0,	op]

									grad = @context.createLinearGradient(l1[0],l1[1],l2[0],l2[1])
									grad.addColorStop '0', 'rgba(' + colA.join(',') + ')'
									grad.addColorStop '1', 'rgba(' + colB.join(',') + ')'

									x1 = l2[0] - l1[0]
									x1 = x1 * x1

									y1 = l2[1] - l1[1]
									y1 = y1 * y1

									dist = Math.sqrt x1 + y1
									dist /= 3

									@context.save()
									@context.beginPath()
									@context.lineWidth = '0.85'
									@context.strokeStyle = grad
									@context.moveTo(l1[0], l1[1])
									@context.bezierCurveTo(l1[0] + dist, l1[1] - dist, l2[0] - dist, l2[1] - dist, l2[0], l2[1])
									@context.stroke()
									@context.restore()

								d[0].forEach _g

							@canvas.select('canvas')
										 .data(@[@lines[1]])
										 .enter()
										 .call(cb)


						d[0].forEach _f

					@canvas.select('canvas')
						 .data(@[@lines[0]])
						 .enter()
						 .call(fn)

					
					null

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
				@context.save()
				@context.fillStyle = 'rgba( 255, 255, 255, 0.5 )'
				@context.lineWidth = '0.2px'
				@context.strokeStyle = 'rgba( 0, 0, 0, 0.7 )'
				@context.beginPath()
				@context.fill()
				@path(@countries)
				@context.fill()
				@path(@neigbors)
				@context.stroke()
				@context.restore()

	onMouseMove				:	()->
		m = d3.mouse @
		
	onMouseWheel			:	(e)=>
		m = d3.event.wheelDeltaY

	onLocationReceived	: (err, data)=>
		console.log data[0]?
		if data[0]?
			country		=	data[0].country
			if country is 'United States'
				if data[0].city?
					city =	data[0].city
					city += ', '
			state			=	data[0].state

			loc = ''
			loc += country + ', '
			if city? then loc += city
			loc += state

			console.log loc
			obj=
				location	:	loc
				latitude	:	data[0].longitude
				longitude	:	data[0].latitude

			EventManager.emitEvent Events.MAP_CLICKED, [obj]
 
	onMouseDownHandler	:		()=>
		#return #for now
		console.log 'mousedown'

		m = d3.event
		coords = [m['offsetX'], m['offsetY']]

		geo_loc = @projection.invert(coords)

		## get location
		str = '/location/' + geo_loc.join('/') + '/'

		d3.json str, @onLocationReceived
	
		switch @renderer
			when 'svg'
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
		switch @renderer
			when 'svg'
				@updateSVG d3.event.translate, d3.event.scale
			when 'canvas'
				@updateCanvas d3.event.translate, d3.event.scale

	updateSVG		:	( pos, scale)	=>
		_str	=	'matrix(' + scale + ',0,0,' + scale + ',' +	pos.join(',') + ')'
		@group.attr('transform', _str)

	updateCanvas	:	( pos, scale)	=>
		_str	=	'translate(' +	pos.join(',') + ')scale(' + scale + ')'

		@context.save()
		@context.clearRect( 0, 0, @width, @height )
		@context.translate( pos[0], pos[1] )
		@context.scale(	scale[0], scale[1] )
		@drawMap()
		@context.restore()

	createProjection	:	()=>
		@projection =	@projector[@projectionType]()
						.scale(@scale)
						.translate([(@width / 2) - @xOffset, (@height / 2) - @yOffset])
						#.clipAngle(120)
						.rotate( @startRotation )
						.precision(.25)

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
