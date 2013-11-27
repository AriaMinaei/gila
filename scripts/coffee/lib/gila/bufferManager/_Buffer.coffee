module.exports = class _Buffer

	self = @

	constructor: (@_manager, @usage = 'STATIC_DRAW') ->

		@gila = @_manager.gila

		@gl = @gila.gl

		if @gila.debug and self._allowedUsages.indexOf(@usage) < 0

			throw Error "Unkown buffer usage type: `#{@usage}`"

		@_usage = @gl[@usage]

		@buffer = @gl.createBuffer()

	data: (data, usage = @_usage) ->

		do @bind

		@gl.bufferData @_type, data, usage

		@

	@_allowedUsages: [
		'STATIC_DRAW', 'DYNAMIC_DRAW', 'STREAM_DRAW'
	]