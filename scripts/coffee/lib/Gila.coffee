ShaderProgram = require './gila/ShaderProgram'
Texture = require './gila/Texture'
Buffer = require './gila/Buffer'
WebGLDebugUtils = require '../../../vendor/webgl-debug/webgl-debug.js'

module.exports = class Gila

	self = @

	constructor: (canvasElOrId, debug = no) ->

		if typeof canvasElOrId is 'string'

			canvas = document.getElementById canvasElOrId

			unless canvas? then throw Error "Can't find canvas with id `#{canvasElOrId}`"

		else

			canvas = canvasElOrId

		@_setCanvas canvas

		@debug = Boolean debug

		do @_setGl

	_setCanvas: (c) ->

		unless c instanceof HTMLCanvasElement

			throw Error "Supplied element is not a canvas"

		@canvas = c

	_setGl: ->

		try context = @canvas.getContext "webgl"

		unless context?

			throw Error "Could not initialize webgl context"

		if @debug

			@gl = WebGLDebugUtils.makeDebugContext context

		else

			@gl = context

	makeProgram: (vertexSource, fragmentSource, id) ->

		new ShaderProgram @, vertexSource, fragmentSource, id

	makeTexture: (url) ->

		new Texture @, url

	setViewoprtDims: (x, y, width, height) ->

		unless x?

			@gl.viewport 0, 0, @canvas.width, @canvas.height

			return @

		if @debug

			if typeof x isnt 'number'

				throw Error "x must be a number"

			if typeof y isnt 'number'

				throw Error "y must be a number"

			if typeof width isnt 'number' or width < 0

				throw Error "width must be a number greater than zero"

			if typeof height isnt 'number' or height < 0

				throw Error "height must be a number greater than zero"

			@gl.viewport x, y, width, height

		return @

	clearFrameBuffer: (type) ->

		unless type?

			type = @gl.COLOR_BUFFER_BIT | @gl.DEPTH_BUFFER_BIT

		else if type is 'color'

			type = @gl.COLOR_BUFFER_BIT

		else if type is 'depth'

			type = @gl.COLOR_DEPTH_BIT

		else

			throw Error "Wrong value for type. Provide null/color/depth"

		@gl.clear type

		@

	enable: (cap) ->

		if @debug and self._enableOrDisableValues.indexOf(cap) is -1

			throw Error "Unkown cap '#{cap}' for gl.enable()"

		@gl.enable @gl[cap]

		@

	disable: (cap) ->

		if @debug and self._enableOrDisableValues.indexOf(cap) is -1

			throw Error "Unkown cap '#{cap}' for gl.disable()"

		@gl.disable @gl[cap]

		@

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

	makeBuffer: (type, usage) ->

		new Buffer @, type, usage

	drawArrays: (mode, first, count) ->

		if @debug and self._drawTypes.indexOf(mode) is -1

			throw Error "Invalid `mode`: '#{mode}'"

		mode = @gl[mode]

		if @debug and parseInt(first) isnt first

			throw Error "`first` must be an integer"

		if @debug and count < 0 or parseInt(count) isnt count

			throw Error "`count` must be an integer above 0"

		@gl.drawArrays mode, first, count

		@

	enableBlending: ->

		@enable 'BLEND'

		@

	disableBlending: ->

		@disable 'BLEND'

		@

	enableDepthTesting: ->

		@enable 'DEPTH_TEST'

		@

	disableDepthTesting: ->

		@disable 'DEPTH_TEST'

		@

	enableFaceCulling: ->

		@enable 'CULL_FACE'

		@

	disableFaceCulling: ->

		@disable 'CULL_FACE'

		@

	enablePolygonOffsetFilling: ->

		@enable 'POLYGON_OFFSET_FILL'

		@

	disablePolygonOffsetFilling: ->

		@disable 'POLYGON_OFFSET_FILL'

		@

	enableScissorTesting: ->

		@enable 'SCISSOR_TEST'

		@

	disableScissorTesting: ->

		@disable 'SCISSOR_TEST'

		@

	cullFace: (mode, enableFaceCulling = yes) ->

		if enableFaceCulling

			do @enableFaceCulling

		unless mode in ['FRONT', 'BACK', 'FRONT_AND_BACK']

			throw Error "Unkown mode '#{mode}' for cullFace"

		mode = @gl[mode]

		@gl.cullFace mode

		@

	@_enableOrDisableValues: [
		'BLEND', 'DEPTH_TEST', 'CULL_FACE',
		'POLYGON_OFFSET_FILL', 'SCISSOR_TEST'
	]

	@_drawTypes: [
		'LINE_STRIP', 'LINES', 'POINTS',
		'TRIANGLE_STRIP', 'TRIANGLES'
	]