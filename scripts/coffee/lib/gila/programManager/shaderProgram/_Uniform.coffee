module.exports = class _Uniform

	constructor: (@gila, @shaderProgram, @name) ->

		@gl = @gila.gl

		@program = @shaderProgram.program

		@location = @gl.getUniformLocation @program, @name