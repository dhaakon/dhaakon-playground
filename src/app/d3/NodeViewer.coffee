class NodeViewer
	constructor		:		(@src) ->
		@load()

	load					:		() ->
		options =
			type				:		'GET'
			url					:		@src
			complete		:		@onloaded
			error				:		(e)-> console.log e

		cb = (data) => console.log data
		$.ajax(options)

	onloaded			:		(data) =>
		str = JSON.stringify data.response
		return
		console.log JSON.parse data.response
		@data = eval data.response
		@status = 'ready'

		EventManager.emitEvent 'onNodeDataLoaded', [@data]

