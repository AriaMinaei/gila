module.exports = class _Uniform

	constructor: (@gila, @shaderProgram, @name) ->

		@gl = @gila.gl

		@program = @shaderProgram.program

		@location = @gl.getUniformLocation @program, @name

		if @gila.debug and not @location?

			throw Error "Couldn't find location of uniform '#{@name}'"