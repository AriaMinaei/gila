module.exports = class Shader

	constructor: (@_gila, @source, type = 'vertex', @id = '') ->

		if @_gila.debug and type not in ['vertex', 'fragment']

			throw Error "Invalid shader type `#{type}"

		@type = type

		@_gl = @_gila.gl

		do @_prepare

	_prepare: ->

		type = if @type is 'vertex' then @_gl.VERTEX_SHADER else @_gl.FRAGMENT_SHADER

		shader = @_gl.createShader type

		@_gl.shaderSource shader, @source
		@_gl.compileShader shader

		if @_gila.debug and not @_gl.getShaderParameter shader, @_gl.COMPILE_STATUS

			throw Error "Error compiling #{@type} shader '#{@id}':" +
				@_gl.getShaderInfoLog shader

		@shader = shader