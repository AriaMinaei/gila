_Buffer = require '../_Buffer'

{ELEMENT_ARRAY_BUFFER} = WebGLRenderingContext

module.exports = class ElementArrayBufferType extends _Buffer

	constructor: ->

		super

		@_type = ELEMENT_ARRAY_BUFFER

	bind: ->

		if @_manager._boundElementArrayBuffer isnt @

			@_gl.bindBuffer ELEMENT_ARRAY_BUFFER, @buffer

			@_manager._boundElementArrayBuffer = @

		@