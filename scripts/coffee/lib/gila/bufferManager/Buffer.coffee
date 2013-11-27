module.exports = class Buffer

	self = @

	constructor: (@_manager, @_type, @usage = 'STATIC_DRAW') ->

		@gila = @_manager

		@gl = @gila.gl

		if @gila.debug and self._allowedUsages.indexOf(@usage) < 0

			throw Error "Unkown buffer usage type: `#{@usage}`"

		@_usage = @gl[@usage]

		@buffer = @gl.createBuffer()

	bind: ->

		if @_manager._bound isnt @

			@gl.bindBuffer @_type, @buffer

			@_manager._bound = @

		@

	data: (data, usage = @_usage) ->

		do @bind

		@gl.bufferData @_type, data, usage

		@

	@_allowedUsages: [
		'STATIC_DRAW', 'DYNAMIC_DRAW', 'STREAM_DRAW'
	]