GetParameterShortcut = require './gila/GetParameterShortcut'
RenderBufferManager = require './gila/RenderBufferManager'
FrameBufferManager = require './gila/FrameBufferManager'
Texture2DManager = require './gila/Texture2DManager'
ExtensionManager = require './gila/ExtensionManager'
WebGLDebugUtils = require '../../../vendor/webgl-debug/webgl-debug.js'
DrawingManager = require './gila/DrawingManager'
ProgramManager = require './gila/ProgramManager'
TextureManager = require './gila/TextureManager'
ShaderManager = require './gila/ShaderManager'
BufferManager = require './gila/BufferManager'
exposeApi = require './gila/utility/exposeApi'

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

		@viewportSize = new Uint16Array 2

		do @_setGl

		do @_initParam

		do @_initExtensionManager

		do @_initFrameBufferManager

		do @_initRenderBufferManager

		do @_initBufferManager

		do @_initShaderManager

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

		@setViewportSize()

		return

	_initExtensionManager: ->

		@extensions = new ExtensionManager @

	_initParam: ->

		@param = new GetParameterShortcut @

	_initDrawingManager: ->

		@_drawingManager = new DrawingManager @

		return

	_initShaderManager: ->

		@_shaderManager = new ShaderManager @

	getFragmentShader: (id, source, variation) ->

		@_shaderManager.getFragmentShader id, source, variation

	getVertexShader: (id, source, variation) ->

		@_shaderManager.getVertexShader id, source, variation

	_initProgramManager: ->

		@_programManager = new ProgramManager @

		return

	getProgram: (vertex, fragment, id, unique) ->

		@_programManager.getProgram vertex, fragment, id, unique

	_initFrameBufferManager: ->

		@_frameBufferManager = new FrameBufferManager @

		return

	makeFrameBuffer: ->

		@_frameBufferManager.make()

	_initRenderBufferManager: ->

		@_renderBufferManager = new RenderBufferManager @

		return

	makeRenderBuffer: ->

		@_renderBufferManager.make()

	_initBufferManager: ->

		@_bufferManager = new BufferManager @

		return

	makeArrayBuffer: ->

		@_bufferManager.makeArrayBuffer()

	makeElementArrayBuffer: ->

		@_bufferManager.makeElementArrayBuffer()

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

	makeImageTexture: (source) ->

		@_texture2DManager.makeImageTexture source

	makeEmptyTexture: ->

		@_texture2DManager.makeEmptyTexture()

	setViewportSize: (w = @gl.drawingBufferWidth, h = @gl.drawingBufferHeight) ->

		if @debug

			if typeof w isnt 'number' or w < 0

				throw Error "w must be a number greater than zero"

			if typeof h isnt 'number' or h < 0

				throw Error "h must be a number greater than zero"

		@viewportSize[0] = w
		@viewportSize[1] = h

		@gl.viewport 0, 0, w, h

		return @

exposeApi DrawingManager, Gila