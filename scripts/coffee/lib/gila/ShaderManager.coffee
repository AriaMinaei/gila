ShaderSource = require './shaderManager/ShaderSource'

FRAG = WebGLRenderingContext.FRAGMENT_SHADER
VERT = WebGLRenderingContext.VERTEX_SHADER

module.exports = class ShaderManager

	constructor: (@_gila) ->

		@_frags = {}

		@_verts = {}

	getFragmentShader: (id, source, flags) ->

		unless @_frags[id]?

			@_makeSource FRAG, id, source

		return @_frags[id].getVariation flags

	getVertexShader: (id, source, flags) ->

		unless @_verts[id]?

			@_makeSource VERT, id, source

		return @_verts[id].getVariation flags

	_makeSource: (type, id, source) ->

		shaderSource = new ShaderSource @, type, id, source

		if type is FRAG

			@_frags[id] = shaderSource

		else

			@_verts[id] = shaderSource

		shaderSource