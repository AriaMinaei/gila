ShaderProgram = require './gila/ShaderProgram'
Buffer = require './gila/Buffer'
Texture = require './gila/Texture'

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

		@viewportDims =

			width: @canvas.width

			height: @canvas.height

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

	prepareToDraw: ->

		# this is probably defining the dimensions of the canvas
		@gl.viewport 0, 0, @viewportDims.width, @viewportDims.height

		# clear the canvas before drawing on it
		@gl.clear @gl.COLOR_BUFFER_BIT | @gl.DEPTH_BUFFER_BIT

	enable: (type) ->

		if @debug and self._enableOrDisableValues.indexOf(type) is -1

			throw Error "Unkown type '#{type}' for gl.enable()"

		@gl.enable @gl[type]

		@

	disable: (type) ->

		if @debug and self._enableOrDisableValues.indexOf(type) is -1

			throw Error "Unkown type '#{type}' for gl.disable()"

		@gl.disable @gl[type]

		@

	clearColor: (r, g, b, a = 1) ->

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

	@_enableOrDisableValues: [
		'BLEND', 'DEPTH_TEST', 'CULL_FACE',
		'POLYGON_OFFSET_FILL', 'SCISSOR_TEST'
	]

	@_drawTypes: [
		'LINE_STRIP', 'LINES', 'POINTS',
		'TRIANGLE_STRIP', 'TRIANGLES'
	]