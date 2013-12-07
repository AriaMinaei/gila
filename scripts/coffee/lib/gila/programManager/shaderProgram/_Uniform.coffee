module.exports = class _Uniform

	constructor: (@_gila, @shaderProgram, @name) ->

		@_gl = @_gila.gl

		@program = @shaderProgram.program

		@location = @_gl.getUniformLocation @program, @name

		if @_gila.debug and not @location?

			throw Error "Couldn't find location of uniform '#{@name}'"

	set: ->

		unless @shaderProgram.isActive()

			throw Error "Cannot set uniform value if the shader program is not active."

		return