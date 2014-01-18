module.exports = (grunt) ->
	options =
		watch :
			options :
				livereload  :   false
			css			:
				files		:	['src/sass/**/*.scss']
				tasks		:	['compass:dev']
			coffee		:
				files		:	['src/app/**/*.coffee']
				tasks		:	['percolator:main']
		compass  :
			dev      :
				options  :
					config   : './src/config.rb'
					cssDir   : './public/stylesheets/'
		copy  :
			main	:
				cwd			:	'./'
				src			:	'bower_components/**/*min.js'
				dest		:	'./public/javascripts/'
				flatten		:	true
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
		coffee		:
			compile		:
				options		:
					bare	:	true
				files	:
					'routes/index.js'	:	'src/routes/index.coffee'
					'routes/user.js'	:	'src/routes/user.coffee'
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

	devOpts =	
		default	:[
				'percolator:main',
				'copy:main',
				'compass:dev',
				'coffee',
				'watch'
				]
		build	:[
				'percolator:server'
				]


	grunt.registerTask		'dev',	devOpts.default
	grunt.registerTask		'default', devOpts.default
	grunt.registerTask		'build', devOpts.build
