{BLEND, DEPTH_TEST, CULL_FACE, POLYGON_OFFSET_FILL, SCISSOR_TEST, FRONT, BACK, FRONT_AND_BACK, TRIANGLES, TRIANGLE_STRIP, LINES, LINE_STRIP, POINTS} = WebGLRenderingContext

[NONE, BOTH, SEPARATE] = [0, 1, 2]

module.exports = class DrawingManager

	constructor: (@gila) ->

		@gl = @gila.gl

		@_capabilities = {}

		@_capabilities[BLEND] = no
		@_capabilities[DEPTH_TEST] = no
		@_capabilities[CULL_FACE] = no
		@_capabilities[POLYGON_OFFSET_FILL] = no
		@_capabilities[SCISSOR_TEST] = no

		@_flags =

			# Type of current face culling
			faceCulling: null

			depthBufferWritable: yes

	_enable: (capability) ->

		unless @_capabilities[capability]

			@gl.enable capability

			@_capabilities[capability] = yes

		@

	_disable: (capability) ->

		if @_capabilities[capability]

			@gl.disable capability

			@_capabilities[capability] = no

		@

	enableBlending: ->

		@_enable BLEND

		@

	disableBlending: ->

		@_disable BLEND

		@

	enableDepthTesting: ->

		@_enable DEPTH_TEST

		@

	disableDepthTesting: ->

		@_disable DEPTH_TEST

		@

	enableFaceCulling: ->

		@_enable CULL_FACE

		@

	disableFaceCulling: ->

		@_disable CULL_FACE

		@

	enablePolygonOffsetFilling: ->

		@_enable POLYGON_OFFSET_FILL

		@

	disablePolygonOffsetFilling: ->

		@_disable POLYGON_OFFSET_FILL

		@

	enableScissorTesting: ->

		@_enable SCISSOR_TEST

		@

	disableScissorTesting: ->

		@_disable SCISSOR_TEST

		@

	cullFront: (enable = yes) ->

		do @enableFaceCulling if enable

		if @_flags.faceCulling isnt FRONT

			@gl.cullFace FRONT

			@_flags.faceCulling = FRONT

		@

	cullBack: (enable = yes) ->

		do @enableFaceCulling if enable

		if @_flags.faceCulling isnt BACK

			@gl.cullFace BACK

			@_flags.faceCulling = BACK

		@

	cullFrontAndBack: (enable = yes) ->

		do @enableFaceCulling if enable

		if @_faceCulling isnt FRONT_AND_BACK

			@gl.cullFace FRONT_AND_BACK

			@_faceCulling = FRONT_AND_BACK

		@

	unlockDepthBuffer: ->

		unless @_flags.depthBufferWritable

			@_flags.depthBufferWritable = yes

			@gl.depthMask yes

		@

	lockDepthBuffer: ->

		if @_flags.depthBufferWritable

			@_flags.depthBufferWritable = no

			@gl.depthMask no

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

		@_drawArrays TRIANGLES, first, count

	drawTriangleStrip: (first, count) ->

		@_drawArrays TRIANGLE_STRIP, first, count

	drawLines: (first, count) ->

		@_drawArrays LINES, first, count

	drawLineStrip: (first, count) ->

		@_drawArrays LINE_STRIP, first, count

	drawPoints: (first, count) ->

		@_drawArrays POINTS, first, count

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