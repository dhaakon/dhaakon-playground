module.exports = (grunt) ->
	options =
		watch     :
			options   :
				livereload      :   false
			css			:
				files   :   ['src/sass/**/*.scss']
				tasks	:	['compass:dev']
			coffee		:
				files	:	['src/coffee/**/*.coffee']
				tasks	:	['percolator:main']
		compass  :
			dev      :
				options  :
					config   : 'src/config.rb'
					cssDir   : 'public/www/css/'
		percolator	:
			main		:
				source		:	'./src/coffee/'
				output		:	'./public/javascripts/Main.js'
				main	  	:	'Main.coffee'
				compile		:	true
		express :
			prod		:
				options		:
					script		:	'./src/express/server.js'
				
	grunt.initConfig options

	grunt.loadNpmTasks 'grunt-contrib-watch'
	grunt.loadNpmTasks 'grunt-contrib-coffee'
	grunt.loadNpmTasks 'grunt-contrib-compass'
	grunt.loadNpmTasks 'grunt-coffee-percolator'

	devOpts =	[
		'percolator:main',
		'compass:dev',
		'watch'
	]

	grunt.registerTask	  	 'dev',	devOpts
	grunt.registerTask	 'default', devOpts
