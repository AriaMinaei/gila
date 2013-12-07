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

	_pointer: (size, type, normalized, stride, offset) ->

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

			if stride % sizes[type] isnt 0

				throw Error "stride must be a multiple of the size of type, which is `#{sizes[type]}`"

			if offset % sizes[type] isnt 0

				throw Error "offset must be a multiple of the size of type, which is `#{sizes[type]}`"

		@_gl.vertexAttribPointer @location, size, type, normalized, stride, offset

		@

	# 4 bytes ~ Float32Array
	readAsFloat: (size, normalized, stride, offset) ->

		@_pointer size, FLOAT, normalized, stride, offset

	# 1 byte (-127 - 127) ~ Int8Array
	readAsByte: (size, normalized, stride, offset) ->

		@_pointer size, BYTE, normalized, stride, offset

	# 1 byte (0 - 255) ~ Uint8Array
	readAsUnsignedByte: (size, normalized, stride, offset) ->

		@_pointer size, UNSIGNED_BYTE, normalized, stride, offset

	# 2 bytes (-32767 to 32767) ~ Int16Array
	readAsShort: (size, normalized, stride, offset) ->

		@_pointer size, SHORT, normalized, stride, offset

	# 2 bytes (0 - 65535) ~ Uint16Array
	readAsUnsignedShort: (size, normalized, stride, offset) ->

		@_pointer size, UNSIGNED_SHORT, normalized, stride, offsett

{FLOAT, BYTE, UNSIGNED_BYTE, SHORT, UNSIGNED_SHORT} = WebGLRenderingContext

sizes = {}
sizes[FLOAT] = 4
sizes[BYTE] = 1
sizes[UNSIGNED_BYTE] = 1
sizes[SHORT] = 2
sizes[UNSIGNED_SHORT] = 2