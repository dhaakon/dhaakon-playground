class PhysicsDemo
	AVOID_MOUSE_STRENGTH : 25000
	SPEED       : 2
	MIN_SPEED   : 1.3
	X_OFFSET    : 300
	Y_OFFSET    : 470

	DESTROY_SIZE : 0.45
	engine      : null
	sketch      : null 
	min_mass    : 2
	max_mass    : 25
  #gui         : new dat.GUI()
	destroy     : false
	renderer    : null
	isDrawingParticles : true 
	isPhysicsRunning : true
	counter     : 0
	max_count   : 205

	#fills				:	['red', 'green', 'blue']

	fills				:	[
								'rgba(0,100,100, 1)',
								'rgba(10,100,100, 1)',
								'rgba(120,120,20, 1)',
								'rgba(130,130,130, 1 )',
								'rgba(100,100,100, 1)',
								]

	timeline    : null

	currentIndex : 0

	constructor : ( @pathImages )->
		@avoidMouse = new Attraction()
		@createSketch()

		@max_index = @pathImages.length
    #@setupGUI()
		#
	changeImage     : (index) ->
		@currentIndex = index

		@X_OFFSET = @pathImages[@currentIndex].offset.x
		@Y_OFFSET = @pathImages[@currentIndex].offset.y

		@createParticles(@pathImages[@currentIndex].points)

	destroySketch   : (cb) ->
		@destroy = true
		EventManager.removeListener Events.WINDOW_RESIZE, @onresize
		if @timeline._duration == 0 then @reset()
		@timeline.eventCallback 'onReverseComplete', ()=>
			@destroy = false
			@reset()
			if cb then cb()

		@timeline.timeScale 5.3
		@timeline.reverse()
    #@timeline.play()
    #@timeline.restart()

	reset            : () ->
		@counter = 0
		@sketch.stop()
		@sketch.clear()
		@sketch.destroy()
		@destroyParticles()

	destroyParticles : () ->
		@engine.destroy()

	setupGUI         : () ->
		@gui.add @, 'AVOID_MOUSE_STRENGTH', 5000, 15000

	onTimelineComplete : ()=>
		@isPhysicsRunning = true

	onresize        : () =>
		@sketch.height = window.innerHeight
		@sketch.width = window.innerWidth
		@redistributeParticles()

	redistributeParticles : ()=>
		for particle in @engine.particles
			target = particle.behaviours[1].target
			target.x = particle.destX + ((@sketch.width/2) - @X_OFFSET)
			target.y = particle.destY + ((@sketch.height/2) - @Y_OFFSET)
			particle.moveTo target

	createSketch    : () ->
		@sketch = Sketch.create( container: document.getElementById "dhaakon-sketch-container")
		@sketch.mousemove = @onmousemove
		@sketch.draw = @draw

		@timeline = new TimelineMax align:"start", onComplete : @onTimelineComplete, stagger:1.5, ease:SlowMo.ease
		@timeline.timeScale 1.4

		EventManager.addListener Events.WINDOW_RESIZE, @onresize

		if @currentIndex + 1 < @max_index then idx = @currentIndex + 1 else idx = 0

		@changeImage(idx)
	delayScale			:		1

	tweenIn         : () ->
		for particle in @engine.particles
			cb = (e)=>
				e.moveTo e.pos

			_onUpdate =(e)=> cb(e)
			randX = Math.random()*0
			randY = Math.random()*0
			_speed = particle.mass/particle.radius/10

			@timeline.insert TweenLite.to particle.pos,_speed, {}= x:particle.behaviours[1].target.x - (randX), y:particle.behaviours[1].target.y - randY, delay:Math.random() * @delayScale, onUpdate:_onUpdate, onUpdateParams:[particle]

		@timeline.play()

	createParticles : (paths) ->
		@engine = new Physics()
		@engine.integrator = new Verlet()

		count = 0
		for path in paths
			for pathData in path.pathData
				particle = new Particle max( @min_mass, random @max_mass)
				position = new Vector random(@sketch.width), random(@sketch.height) 

				@count++
				particle.endRadius = random 8
				particle.setRadius = 0
				particle.moveTo position

				particle.destX = pathData.x
				particle.destY = pathData.y

				particle.color	=	@fills[Math.floor(@fills.length * Math.random())]


				pull = new Attraction()
				pull.target.x = pathData.x + ((@sketch.width/2) - @X_OFFSET)
				pull.target.y = pathData.y + ((@sketch.height/2) - @Y_OFFSET)
				pull.strength = Math.max 5000 * Math.random(), 3000

				particle.behaviours.push @avoidMouse, pull

				@engine.particles.push particle

		@avoidMouse.setRadius 100
		@avoidMouse.strength = -@AVOID_MOUSE_STRENGTH
		@tweenIn()

	timerCallback : ()->
		@destroySketch (=>@createSketch())

	draw            : () =>
		if @isPhysicsRunning then @engine.step()
		@sketch.shadowBlur = 0
		@sketch.shadowOffsetX = 0
		@sketch.shadowOffsetY = 0

		@sketch.fillStyle = 'rgba(' + [ 211,211,211, 0.17].join(',') + ')' 
		@sketch.fillRect(0, 0,  @sketch.width, @sketch.height)


		if @counter < @max_count
			@counter++
		else
			@counter = 0
			@timerCallback()

		@avoidMouse.strength = -@AVOID_MOUSE_STRENGTH
		if @isDrawingParticles then @drawParticles()

	drawParticles : ()->
		for particle in @engine.particles
			if @destroy
				if particle.radius > 0 then particle.radius -= @DESTROY_SIZE
			else
				if particle.radius < particle.endRadius then particle.radius += @DESTROY_SIZE

			if particle.radius > 0
				if @destroy then _type = "stroke" else _type = "fill"
				@drawCircle particle.pos.x, particle.pos.y, particle.radius, 'fill', particle.color

	drawCircle    : ( x, y, radius, type, color )->
		@sketch.fillStyle = color
		@sketch.beginPath()
		@sketch.arc x, y, radius, 0, Math.PI * 2
		#@sketch.shadowBlur = 2
		#@sketch.shadowOffsetX = 0
		#@sketch.shadowOffsetY = 0
		#@sketch.shadowColor = 'black'
		@sketch[type]()

	onmousemove     : () =>
		@avoidMouse.target.x = @sketch.mouse.x
		@avoidMouse.target.y = @sketch.mouse.y

	getSketch       : () -> return @sketch
