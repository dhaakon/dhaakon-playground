#import Map.coffee

class Main
	JSON_PATH	:	'json/world.json'
	map			:	null
	constructor	:	()->
		console.log 'Main Started'
		@createMap()

	createMap	:	()->
		@map = new Map(@JSON_PATH, $(window).width(), $(window).height())

$(document).ready( (=> new Main() ) )
