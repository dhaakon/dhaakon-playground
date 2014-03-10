#import data/ParticleData.coffee
#import TypePath.coffee
#import EventManager.coffee
#import PhysicsDemo.coffee

class Voronoi
	CANVAS				:		'#dhaakon-sketch-container'
	numPoints			:		100

	canvas				:		null
	ctx						:		null
	constructor		:		()->
		@createPaths()

		r = d3.range 0, @numPoints

	createPaths		:		()->
		tp = new TypePath()
		new PhysicsDemo tp.getPaths()

init = () =>
	new Voronoi()

$(window).ready (=>init())
