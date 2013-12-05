module.exports = class VertexAttribute

	constructor: (@_gila, @shaderProgram, @name) ->

		@_gl = @_gila.gl

		@program = @shaderProgram.program

		loc = @_gl.getAttribLocation @program, @name

		if @_gila.debug and loc is -1

			throw Error "Could not get shader attribute location `#{@name}` for shader `#{@shaderProgram.id}`"

		@location = loc

	enableVertexAttribArray: ->

		@_gl.enableVertexAttribArray @location

		@

	enable: ->

		do @enableVertexAttribArray

	_vertexAttribPointer: (size, type, normalized, stride, offset) ->

		# Bottleneck

		if @_gila.debug

			unless @_gila.getBoundArrayBuffer()

				throw Error "There is no bound array buffer to read from"

			unless size in [1, 2, 3, 4]

				throw Error "Invalid size `#{size}"

			unless normalized in [true, false]

				throw Error "Invalid value for normalized: #{normalized}"

			unless 0 <= stride <= 255

				throw Error "stride is out of range: `#{stride}"

			if offset < 0

				throw Error "offset is out of range: `#{offset}`"

		@_gl.vertexAttribPointer @location, size, type, normalized, stride, offset

		@

	readAsFloat: (size, normalized, stride, offset) ->

		@_vertexAttribPointer size, @_gl.FLOAT, normalized, stride, offset

	readAsByte: (size, normalized, stride, offset) ->

		@_vertexAttribPointer size, @_gl.BYTE, normalized, stride, offset

	readAsUnsignedByte: (size, normalized, stride, offset) ->

		@_vertexAttribPointer size, @_gl.UNSIGNED_BYTE, normalized, stride, offset

	readAsShort: (size, normalized, stride, offset) ->

		@_vertexAttribPointer size, @_gl.SHORT, normalized, stride, offset

	readAsUnsignedShort: (size, normalized, stride, offset) ->

		@_vertexAttribPointer size, @_gl.UNSIGNED_SHORT, normalized, stride, offset

	readAsFixed: (size, normalized, stride, offset) ->

		@_vertexAttribPointer size, @_gl.FIXED, normalized, stride, offset