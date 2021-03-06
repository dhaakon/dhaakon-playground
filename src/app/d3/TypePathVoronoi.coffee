#<< ParticleData

class TypePath
	STEP_SIZE   :   14
	images      :   ParticleImages

	ctx         :   null
	lines       :   []
	imagesData  :   []
	paths       :   []

	constructor :   () ->
		@svg = new SVG 'svgElement'

		for image in @images
			group = @svg.group()
			_image = paths:[], name:image.name, points:[], offset:image.offset

			for path in image.paths
				_path = group.path()
				_path.attr 'd', path
				_image.paths.push _path

			@imagesData.push _image

		@getPoints()

	getPoints   :   () ->
		for imageData in @imagesData
			pathData = []
			for line in imageData.paths
				path = {}
				totalLength = path.totalLength = ~~ line.node.getTotalLength()

				while totalLength > 0
					point = line.node.getPointAtLength totalLength

					pathData.push [point.x, point.y]
					totalLength -= @STEP_SIZE

				path.pathData = pathData

				imageData.points.push path

			@paths.push imageData

	getPaths    :   () ->
		return @paths
