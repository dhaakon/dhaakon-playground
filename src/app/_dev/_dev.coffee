

class DevConsole
	option					:
		mode						:		'coffeescript'
		lineNumbers			:		'true'
		#tabSize					:		2
		#indentWithTabs	:		true	
		keyMap					:		'vim'
		theme						:		'night'
		lineWrapping		:		true
		autoMatchParens	:		false
		passDelay				:		50
		path						:		'javascripts/'
		tabMode					:		'shift'

	container				:		null
	size						:		null

	constructor		:		(@element)->
		@container	=		document.getElementById 'dev'

		@setUpContainer()
		@setUpCodeMirror()

	setUpContainer	:		()->
		@setContainerSize()

	setContainerSize	:		()->
		@size	=
			width				:		@getWidth()	
			height			:		@getHeight()/2

		$(@container).css @size
		

	setUpCodeMirror		:		()->
		@option.content		=		@element.value
		@codeMirror = CodeMirror.fromTextArea @element, @option
		@codeMirror.setValue '# CoffeeScript'
		console.log @codeMirror
	
	getWidth					:		()->
		return $(window).width()

	getHeight					:		()->
		return $(window).height()


init = ()=>
	console.log 'dev'
	element = document.getElementById 'codem'
	new DevConsole element

$(document).ready (=> init())
