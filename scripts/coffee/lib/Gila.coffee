GetParameterShortcut = require './gila/GetParameterShortcut'
Texture2DManager = require './gila/Texture2DManager'
WebGLDebugUtils = require '../../../vendor/webgl-debug/webgl-debug.js'
DrawingManager = require './gila/DrawingManager'
ProgramManager = require './gila/ProgramManager'
TextureManager = require './gila/TextureManager'
BufferManager = require './gila/BufferManager'
ShaderProgram = require './gila/ShaderProgram'
exposeApi = require './gila/utility/exposeApi'
Texture = require './gila/Texture'
Buffer = require './gila/Buffer'

# we better not lose context, or all hell will break loose
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

		do @_initParam

		do @_initBufferManager

		do @_initProgramManager

		do @_initTextureManager

		do @_initTexture2DManager

		do @_initDrawingManager

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

		return

	_initParam: ->

		@param = new GetParameterShortcut @

	_initDrawingManager: ->

		@_drawingManager = new DrawingManager @

		return

	_initProgramManager: ->

		@_programManager = new ProgramManager @

		return

	makeProgram: (vertexSource, fragmentSource, id) ->

		@_programManager.makeProgram vertexSource, fragmentSource, id

	_initBufferManager: ->

		@_bufferManager = new BufferManager @

		return

	makeArrayBuffer: (usage) ->

		@_bufferManager.makeArrayBuffer usage

	makeElementArrayBuffer: (usage) ->

		@_bufferManager.makeElementArrayBuffer usage

	getBoundArrayBuffer: ->

		@_bufferManager.getBoundArrayBuffer()

	getBoundElementArrayBuffer: ->

		@_bufferManager.getBoundElementArrayBuffer()

	_initTextureManager: ->

		@_textureManager = new TextureManager @

		return

	_initTexture2DManager: ->

		@_texture2DManager = new Texture2DManager @

		return

	makeTexture: (source) ->

		@_texture2DManager.makeTexture source

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

exposeApi DrawingManager, Gila