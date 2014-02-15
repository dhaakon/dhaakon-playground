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
									'percolator:main',
									'percolator:routes',
									'percolator:dev',
									'copy:codemirror'
								]

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


		percolator	:
			main		:
				source		:	'./src/app/'
				output		:	'./public/javascripts/Main.js'
				main	  	:	'Main.coffee'
				compile		:	true

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


		express		:
			prod		:
				options		:
					script		:	'./src/express/server.js'
				
	grunt.initConfig options

	grunt.loadNpmTasks 'grunt-contrib-watch'
	grunt.loadNpmTasks 'grunt-contrib-compass'
	grunt.loadNpmTasks 'grunt-coffee-percolator'
	grunt.loadNpmTasks 'grunt-contrib-copy'
	grunt.loadNpmTasks 'grunt-contrib-coffee'
	grunt.loadNpmTasks 'grunt-foreman'

	devOpts =	
		default	:	[
					'percolator:main',
					'percolator:dev',
					'copy:main',
					'compass:dev',
					'copy:codemirror',
					'copy:codemirror_addons',
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

	grunt.registerTask		'dev',		devOpts.default
	grunt.registerTask		'serve',	devOpts.serve
	grunt.registerTask		'default',	devOpts.default
	grunt.registerTask		'build',	devOpts.build
