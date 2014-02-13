class TGS
	src						:		Config.TGS.src
	constructor		:		()->
		d3.json @src, @onTGSDataLoaded

	onTGSDataLoaded		:		(data)->
		console.log data
		console.log 'tgs'

		_main = d3.select('#main')

		_main.selectAll('p')
				 .data(data)
				 .enter()
				 .append('p')
				 .html((d)=> return d.location.title + '\t\n' + d.location.coords[0].latitude + '\t\t' + d.location.coords[0].longitude)
