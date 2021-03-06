#import data/ParticleData.coffee
#import TypePathVoronoi.coffee
#import EventManager.coffee
#import PhysicsDemo.coffee
#import NodeViewer.coffee

CANVAS				=		'#dhaakon-sketch-container'

mr = Math.random
mf = Math.floor
mmax = Math.max
mmin = Math.min

btw = (x1, x2) ->
	t = (mr() * (x2 - x1)) + x1
	return t

class Voronoi
	numPoints			:		100

	canvas				:		null
	ctx						:		null
	voronoi				:		null
	t							:		0
	numParticles	:		40
	pulls					:		[]
	stepSize			:		8

	X_OFFSET			: 400
	Y_OFFSET			: -200
	AVOID_MOUSE_STRENGTH : 25000

	constructor		:		()->

		@nv = new NodeViewer('/json/tiger.json')

		cb = (d)-> console.log d

		EventManager.addListener 'onNodeDataLoaded', cb

		return
		tp = new TypePath()

		@width	= $(window).width()
		@height	= $(window).height()

		fn = (d)=> return [Math.random() * @width, Math.random() * @height]

		@rand = d3.range(@numPoints)
								 .map(fn)

		@vertices = tp.getPaths()[0].points[0].pathData

		for point in @vertices
			point[0] += ((@width/2) - @X_OFFSET)
			point[1] += ((@height/2) + @Y_OFFSET)

		@voronoi = d3.geom.voronoi().clipExtent([0.0],[@width, @height])

		@particle = new Particle( 3 )
		@createSketch()

		@redraw()
	
	createPhysics	:		()->
		console.log 'b'
		@engine = new Physics()
		@engine.integrator = new Verlet
		@avoidMouse = new Attraction()
	
		while --@numParticles > 0
			particle = new Particle
			particle.endRadius = random 8
			particle.setRadius = 0

			r1 = Math.floor(random @vertices.length)

			particle.moveTo new Vector( @vertices[r1][0], @vertices[r1][1] )

			pull = new Attraction()
			pull.target.x = random @width
			pull.target.y = random @height
			pull.strength = 50

			@pulls.push pull

			particle.behaviours.push pull
			@engine.particles.push particle

		return

	redraw				:		()=>
		@triangles = @voronoi.triangles @vertices

		@sketch.fillStyle = 'rgba(' + [ 211,211,211, 0.27].join(',') + ')'
		@sketch.fillRect(0,0,@width, @height)

		for triangle in @triangles	
			@createTriangle triangle

		return

		@svg.html('')
		@path		=		@svg.append('g').selectAll('path')		
		path = @path.data(@triangles)

		path.exit().remove()

		path.enter()
				 .append('path')
				 .attr('d', @polygon )
				 .attr('fill', @fill)
				 .attr('stroke', @fill)

		path.order()

	createTriangle	:		(triangle)->
		@sketch.beginPath()
		
		@sketch.moveTo triangle[0][0], triangle[0][1]
		@sketch.lineTo triangle[1][0], triangle[1][1]
		@sketch.lineTo triangle[2][0], triangle[2][1]
		@sketch.lineTo triangle[0][0], triangle[0][1]

		@sketch.fillStyle = @fill()
		@sketch.fill()
		
		@sketch.strokeStyle = @fill()
		@sketch.stroke()

	fill					:		(d)->
		r = mf mr() * btw(0, 255)
		g = mf mr() * btw(55, 65)
		b = mf mr() * btw(200, 205)
		a = 0.25

		col = [ r,g,b,a ].join(',')

		return 'rgba(' + col + ')'

	polygon				:		(d)->
		return	'M' + d.join('L') + 'Z'
    
	createSketch	:		()->
		opts =
			container		:		$(CANVAS)[0]

		@sketch = Sketch.create opts
		@createPhysics()
		@sketch.draw = @draw
		@sketch.lineWidth = '0.1px'

		@sketch.mousemove = @mousemove

		return

	mousemove			:		(e)=>
		#@currentMouse = [@sketch.mouse.x, @sketch.mouse.y]
		#@avoidMouse.target.x = @sketch.mouse.x
		#@avoidMouse.target.y = @sketch.mouse.y
		#@pull.target.x = @sketch.mouse.x
		#@pull.target.y = @sketch.mouse.y

		#@vertices[0] = @currentMouse
		#@redraw()

	draw					:		()=>
		console.log 'a'
		@t++

		if @t % 100 is 1
			for pull in @pulls
				pull.target.x = random @width
				pull.target.y = random @height

		@engine.step()
	
		f = 0

		for particle in @engine.particles
			x= particle.pos.x
			y= particle.pos.y

			@vertices[f * @stepSize] = [ x, y ]
			
			++f

		@redraw()

		return

	createSVG			:		()->
		@svg = d3.select('body').append('svg')
						 .attr('width', @width)
						 .attr('height', @height)
						 .on("mousemove", ()=>
								@currentMouse = d3.mouse($('svg')[0])
								@redraw()
							)

class RGB
	constructor		:		()->
		opts				=
			container : $(CANVAS)[0]
			width			:	255
			height		:	255
			fullscreen: false
	
		opts.container.style.width = '255px'
		opts.container.style.height = '255px'

		@sketch = Sketch.create opts
		@sketch.draw	=		@draw

	draw					:		(e)=>
		@sketch.clear()
		
init = () =>
	console.log 'a'
	new Voronoi()

$(window).ready (=>init())
