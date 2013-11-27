module.exports = class VertexAttribute

	constructor: (@gila, @shaderProgram, @name) ->

		@gl = @gila.gl

		@program = @shaderProgram.program

		loc = @gl.getAttribLocation @program, @name

		if loc is -1

			throw Error "Could not get shader attribute location `#{@name}` for shader `#{@shaderProgram.id}`"

		@location = loc

	enableVertexAttribArray: ->

		@gl.enableVertexAttribArray @location

		@

	enable: ->

		do @enableVertexAttribArray

	vertexAttribPointer: (size, type, normalized, stride, offset) ->

		if @gila.debug

			unless @gila.getBoundArrayBuffer()

				throw Error "There is no bound array buffer to read from"

			unless size in [1, 2, 3, 4]

				throw Error "Invalid size `#{size}"

			unless type in ['FLOAT', 'BYTE', 'UNSIGNED_BYTE', 'SHORT', 'UNSIGNED_SHORT', 'FIXED']

				throw Error "Invalid type: #{type}"

			unless normalized in [true, false]

				throw Error "Invalid value for normalized: #{normalized}"

			unless 0 <= stride <= 255

				throw Error "stride is out of range: `#{stride}"

			if offset < 0

				throw Error "offset is out of range: `#{offset}`"

		type = @gl[type]

		@gl.vertexAttribPointer @location, size, type, normalized, stride, offset

		@

	readFromBuffer: ->

		@vertexAttribPointer.apply @, arguments