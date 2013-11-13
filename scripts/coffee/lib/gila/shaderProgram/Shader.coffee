module.exports = class Shader

	constructor: (@gila, @source, type = 'vertex', @id = '') ->

		if @gila.debug and type not in ['vertex', 'fragment']

			throw Error "Invalid shader type `#{type}"

		@type = type

		@gl = @gila.gl

		do @_prepare

	_prepare: ->

		type = if @type is 'vertex' then @gl.VERTEX_SHADER else @gl.FRAGMENT_SHADER

		shader = @gl.createShader type

		@gl.shaderSource shader, @source
		@gl.compileShader shader

		if @gila.debug and not @gl.getShaderParameter shader, @gl.COMPILE_STATUS

			throw Error "Error compiling #{@type} shader '#{@id}':" +
				@gl.getShaderInfoLog shader

		@shader = shader