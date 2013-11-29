module.exports = class DrawingManager

	constructor: (@gila) ->

		@gl = @gila.gl

	enableBlending: ->

		@enable @gl.BLEND

		@

	disableBlending: ->

		@disable @gl.BLEND

		@

	enableDepthTesting: ->

		@enable @gl.DEPTH_TEST

		@

	disableDepthTesting: ->

		@disable @gl.DEPTH_TEST

		@

	enableFaceCulling: ->

		@enable @gl.CULL_FACE

		@

	disableFaceCulling: ->

		@disable @gl.CULL_FACE

		@

	enablePolygonOffsetFilling: ->

		@enable @gl.POLYGON_OFFSET_FILL

		@

	disablePolygonOffsetFilling: ->

		@disable @gl.POLYGON_OFFSET_FILL

		@

	enableScissorTesting: ->

		@enable @gl.SCISSOR_TEST

		@

	disableScissorTesting: ->

		@disable @gl.SCISSOR_TEST

		@

	enable: (what) ->

		@gl.enable what

		@

	cullFace: (mode, enableFaceCulling = yes) ->

		if enableFaceCulling

			do @enableFaceCulling

		unless mode in ['FRONT', 'BACK', 'FRONT_AND_BACK']

			throw Error "Unkown mode '#{mode}' for cullFace"

		mode = @gl[mode]

		@gl.cullFace mode

		@

	_drawArrays: (mode, first, count) ->

		if @debug

			if parseInt(first) isnt first

				throw Error "`first` must be an integer"

			if count < 1 or parseInt(count) isnt count

				throw Error "`count` must be an integer above 0"

		@gl.drawArrays mode, first, count

		@

	drawTriangles: (first, count) ->

		@_drawArrays @gl.TRIANGLES, first, count

	drawTriangleStrip: (first, count) ->

		@_drawArrays @gl.TRIANGLE_STRIP, first, count

	drawLines: (first, count) ->

		@_drawArrays @gl.LINES, first, count

	drawLineStrip: (first, count) ->

		@_drawArrays @gl.LINE_STRIP, first, count

	drawPoints: (first, count) ->

		@_drawArrays @gl.POINTS, first, count

	@_blendingFactors: [
		'ZERO', 'ONE', 'SRC_COLOR', 'ONE_MINUS_SRC_COLOR',
		'DST_COLOR', 'ONE_MINUS_DST_COLOR', 'SRC_ALPHA',
		'ONE_MINUS_SRC_ALPHA', 'DST_ALPHA', 'ONE_MINUS_DST_ALPHA',
		'SRC_ALPHA_SATURATE'
	]

	setClearColor: (r, g, b, a = 1) ->

		if @debug

			args = []

			for val in [r, g, b, a]

				unless 0 <= val <= 1

					throw Error "You have a color component out of range: #{val}"

				args.push parseFloat val

			@gl.clearColor.apply @gl, args

		else

			@gl.clearColor parseFloat(r), parseFloat(g), parseFloat(b), parseFloat(a)

		@