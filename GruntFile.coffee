module.exports = (grunt) ->
	options =
		watch :
			options :
				livereload  :   false

			css			:
				files		:	['src/sass/**/*.scss']
				tasks		:	['compass:dev']

			coffee		:
				files		:	['src/app/**/*.coffee', 'src/routes/**/*.coffee']
				tasks		:	[
									#'percolator:main',
									#'percolator:routes',
									#'percolator:dev',
									'percolator:d3',
									'copy:codemirror'
								]
			assets		:
				files		:	['src/assets/**/*']
				tasks		:	['copy:assets']

		compass  :
			dev      :
				options  :
					config   : './src/config.rb'
					cssDir   : './public/stylesheets/'

		copy  :
			main	:
				cwd			:	'./'
				src			:	[
									'bower_components/**/*min.js',
									'bower_components/**/**/*min.js',
									'bower_components/codemirror/lib/codemirror.js'
									'bower_components/codemirror/addon/coffeescript/coffeescript.js'
									'bower_components/**/javascript.js'
									'bower_components/**/keymap/*.js'
									'node_modules/socket.io/lib/socket.io.js'
								]
				dest		:	'./public/javascripts/'
				flatten		:	true
				expand		:	true

			codemirror		:
				src			:	[
									'bower_components/codemirror/theme/*.css',
									'bower_components/codemirror/lib/codemirror.css',
									'bower_components/coffeescript-codemirror-mode/lib/codemirror/mode/coffeescript/coffeescript.css'
								]
				dest		:	'./public/stylesheets/'
				flatten		:	true
				expand		:	true

			codemirror_addons	:
				cwd			:	'./bower_components/codemirror/'
				src			:	'addon/**/*.js'
				dest		:	'./public/javascripts'
				flatten		:	false
				expand		:	true
			assets	:
				cwd			:	'./src/assets/'
				src			:	'**/*'
				dest		:	'./public/assets/'
				flatten		:	false
				expand		:	true

		percolator	:
			main		:
				source		:	'./src/app'
				output		:	'./public/javascripts/Main.js'
				main	  	:	'Main.coffee'
				compile		:	true
				#opts		:	'--minify'

			server		:
				source		:	'./src/express/'
				output		:	'./app.js'
				main		:	'app.coffee'
				compile		:	true

			dev			:
				source		:	'./src/app/_dev'
				output		:	'./public/javascripts/_dev.js'
				main		:	'_dev.coffee'
				compile		:	true

			routes		:
				source	:	'src/routes/'
				output	:	'routes/routes.js'
				main	:	'main.coffee'
				compile	:	true
				#opts	:	'--bare'
				#
			d3				:
				source	:	'./src/app/d3'
				output	:	'./public/javascripts/main.d3.js'
				main		:	'Main.coffee'
				compile	:	true

		express		:
			prod		:
				options		:
					script		:	'./src/express/server.js'
		###
		xsltproc	:		
			options		:
				stylesheet	:		'./src/xslt/svg2gfx.xslt'
			compile		:
				files		:
					'public/json/tiger.json'	:		['src/svg/tiger.svg']
		###
		svg2json	:
			options		:
				isAnimation		:		true
			compile		:
				files		:
					'public/json/svg2json.json' : ['src/svg/*.svg']
			
				
	grunt.initConfig options

	grunt.loadNpmTasks 'grunt-contrib-watch'
	grunt.loadNpmTasks 'grunt-contrib-compass'
	grunt.loadNpmTasks 'grunt-coffee-percolator'
	grunt.loadNpmTasks 'grunt-contrib-copy'
	grunt.loadNpmTasks 'grunt-contrib-coffee'
	grunt.loadNpmTasks 'grunt-foreman'
	grunt.loadNpmTasks 'grunt-xsltproc'
	grunt.loadNpmTasks 'grunt-svg2json'

	commands =	
		default	:	[
					'percolator:main',
					'percolator:dev',
					'copy:main',
					'compass:dev',
					'copy:codemirror',
					'copy:codemirror_addons',
					'copy:assets',
					'percolator:routes',
					'watch'
					]

		build	:	[
					'percolator:server'
					]

		serve	:	[
					'percolator:server',
					'foreman'
					]

		d3		:	[
					'percolator:d3'
					'watch'
					]

		xslt	: [
					'xsltproc'
					]

		svg		:		['svg2json']

	grunt.registerTask		'dev',			commands.default
	grunt.registerTask		'd3',				commands.d3
	grunt.registerTask		'serve',		commands.serve
	grunt.registerTask		'default',	commands.default
	grunt.registerTask		'build',		commands.build
	grunt.registerTask		'xslt',			commands.xslt
	grunt.registerTask		'svg',				commands.svg
