module.exports = class Uniform

	constructor: (@gila, @shaderProgram, @name) ->

		@gl = @gila.gl

		@program = @shaderProgram.program

		@location = @gl.getUniformLocation @program, @name

	set1f: (n) ->

		if @gila.debug and parseFloat(n) isnt n

			throw Error "n must be a float. Given: '#{n}'"

		@gl.uniform1f @location, n

		@