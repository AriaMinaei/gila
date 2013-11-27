_Buffer = require '../_Buffer'

module.exports = class ElementArrayBufferType extends _Buffer

	constructor: ->

		super

		@_type = @gl.ELEMENT_ARRAY_BUFFER

	bind: ->

		if @_manager._boundElementArrayBuffer isnt @

			@gl.bindBuffer @_type, @buffer

			@_manager._boundElementArrayBuffer = @

		@