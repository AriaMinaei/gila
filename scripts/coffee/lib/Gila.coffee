ShaderProgram = require './gila/ShaderProgram'
Texture = require './gila/Texture'
Buffer = require './gila/Buffer'
WebGLDebugUtils = require '../../../vendor/webgl-debug/webgl-debug.js'

ProgramManager = require './gila/ProgramManager'
BufferManager = require './gila/BufferManager'

module.exports = class Gila

	self = @

	constructor: (canvasElOrId, debug = no) ->

		if typeof canvasElOrId is 'string'

			canvas = document.getElementById canvasElOrId

			unless canvas? then throw Error "Can't find canvas with id `#{canvasElOrId}`"

		else

			canvas = canvasElOrId

		@debug = Boolean debug

		@_setCanvas canvas

		do @_setGl

		do @_initBufferManager

		do @_initProgramManager

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

	_initProgramManager: ->

		@_programManager = new ProgramManager @



	makeProgram: (vertexSource, fragmentSource, id) ->

		@_programManager.makeProgram vertexSource, fragmentSource, id

	_initBufferManager: ->

		@_bufferManager = new BufferManager @

	makeArrayBuffer: (usage) ->

		@_bufferManager.makeArrayBuffer usage

	makeElementArrayBuffer: (usage) ->

		@_bufferManager.makeElementArrayBuffer usage

	makeTexture: (url) ->

		new Texture @, url

	setViewportDims: (x, y, width, height) ->

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