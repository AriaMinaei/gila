_Buffer = require '../_Buffer'

{ARRAY_BUFFER} = WebGLRenderingContext

module.exports = class ArrayBufferType extends _Buffer

	constructor: ->

		super

		@_type = ARRAY_BUFFER

	bind: ->

		if @_manager._boundArrayBuffer isnt @

			@_gl.bindBuffer ARRAY_BUFFER, @buffer

			@_manager._boundArrayBuffer = @

		@