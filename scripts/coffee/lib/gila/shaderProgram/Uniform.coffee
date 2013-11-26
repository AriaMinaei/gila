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

	set2f: (x, y) ->

		if @gila.debug

			if parseFloat(x) isnt x

				throw Error "x must be a float. Given: '#{x}'"

			if parseFloat(y) isnt y

				throw Error "y must be a float. Given: '#{y}'"

		@gl.uniform2f @location, x, y

		@

	set3f: (x, y, z) ->

		if @gila.debug

			if parseFloat(x) isnt x

				throw Error "x must be a float. Given: '#{x}'"

			if parseFloat(y) isnt y

				throw Error "y must be a float. Given: '#{y}'"

			if parseFloat(z) isnt z

				throw Error "z must be a float. Given: '#{z}'"

		@gl.uniform3f @location, x, y, z

		@