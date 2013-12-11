exposeApi = require './utility/exposeApi'
BlendManager = require './drawingManager/BlendManager'
CapabilityManager = require './drawingManager/CapabilityManager'

module.exports = class DrawingManager

	constructor: (@_gila) ->

		@_gl = @_gila.gl

		@blend = new BlendManager @

		@_flags =

			# Type of current face culling
			faceCulling: null

			depthBufferWritable: yes

		@_capabilityManager = new CapabilityManager @

	cullFront: (enable = yes) ->

		do @enableFaceCulling if enable

		if @_flags.faceCulling isnt FRONT

			@_gl.cullFace FRONT

			@_flags.faceCulling = FRONT

		@

	cullBack: (enable = yes) ->

		do @enableFaceCulling if enable

		if @_flags.faceCulling isnt BACK

			@_gl.cullFace BACK

			@_flags.faceCulling = BACK

		@

	cullFrontAndBack: (enable = yes) ->

		do @enableFaceCulling if enable

		if @_faceCulling isnt FRONT_AND_BACK

			@_gl.cullFace FRONT_AND_BACK

			@_faceCulling = FRONT_AND_BACK

		@

	unlockDepthBuffer: ->

		unless @_flags.depthBufferWritable

			@_flags.depthBufferWritable = yes

			@_gl.depthMask yes

		@

	lockDepthBuffer: ->

		if @_flags.depthBufferWritable

			@_flags.depthBufferWritable = no

			@_gl.depthMask no

		@

	_drawArrays: (mode, first, count) ->

		do @blend._apply

		if @debug

			if parseInt(first) isnt first

				throw Error "`first` must be an integer"

			if count < 1 or parseInt(count) isnt count

				throw Error "`count` must be an integer above 0"

		@_gl.drawArrays mode, first, count

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

	setClearColor: (r, g, b, a = 1) ->

		if @debug

			args = []

			for val in [r, g, b, a]

				unless 0 <= val <= 1

					throw Error "You have a color component out of range: #{val}"

				args.push parseFloat val

			@_gl.clearColor.apply @_gl, args

		else

			@_gl.clearColor parseFloat(r), parseFloat(g), parseFloat(b), parseFloat(a)

		@

	clearColorBuffer: ->

		@_gl.clear COLOR_BUFFER_BIT

		return

	clearDepthBuffer: ->

		@_gl.clear DEPTH_BUFFER_BIT

		return

	clear: ->

		@_gl.clear BOTH_BUFFER_BITS

		return

	@_methodsToExpose: '*'

	@_propsToExpose: ['blend'].concat CapabilityManager._propsToExpose

	@_memberName: '_drawingManager'

exposeApi CapabilityManager, DrawingManager

[NONE, BOTH, SEPARATE] = [0, 1, 2]
{TRIANGLES, TRIANGLE_STRIP, LINES, LINE_STRIP, POINTS} = WebGLRenderingContext
{COLOR_BUFFER_BIT, DEPTH_BUFFER_BIT} = WebGLRenderingContext
BOTH_BUFFER_BITS = COLOR_BUFFER_BIT | DEPTH_BUFFER_BIT