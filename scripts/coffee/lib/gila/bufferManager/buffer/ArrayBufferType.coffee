_Buffer = require '../_Buffer'

module.exports = class ArrayBufferType extends _Buffer

	constructor: ->

		super

		@_type = @_gl.ARRAY_BUFFER

	bind: ->

		if @_manager._boundArrayBuffer isnt @

			@_gl.bindBuffer @_type, @buffer

			@_manager._boundArrayBuffer = @

		@