FRAG = WebGLRenderingContext.FRAGMENT_SHADER
VERT = WebGLRenderingContext.VERTEX_SHADER

shaderNames = {}
shaderNames[FRAG] = 'fragment'
shaderNames[VERT] = 'vertex'

module.exports = class Shader

	constructor: (@_sourceManager, @type, @sourceId, @variation, @source) ->

		@_gila = @_sourceManager._gila

		@_gl = @_gila.gl

		@index = @sourceId

		if @variation > 0

			@index += "-#{@variation}"

		@shader = null

	getVariation: (flags) ->

		@_sourceManager.getVariation flags

	ready: ->

		return @ if @shader?

		shader = @_gl.createShader @type

		@_gl.shaderSource shader, @source
		@_gl.compileShader shader

		if @_gila.debug and not @_gl.getShaderParameter shader, @_gl.COMPILE_STATUS

			throw Error "Error compiling #{shaderNames[@type]} shader '#{@index}':\n" +
				@_gl.getShaderInfoLog shader

		@shader = shader