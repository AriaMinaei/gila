module.exports = class _Buffer

	self = @

	constructor: (@_manager, @usage = 'STATIC_DRAW') ->

		@_gila = @_manager._gila

		@_gl = @_gila.gl

		if @_gila.debug and self._allowedUsages.indexOf(@usage) < 0

			throw Error "Unkown buffer usage type: `#{@usage}`"

		@_usage = @_gl[@usage]

		@buffer = @_gl.createBuffer()

	data: (data, usage = @_usage) ->

		do @bind

		@_gl.bufferData @_type, data, usage

		@

	@_allowedUsages: [
		'STATIC_DRAW', 'DYNAMIC_DRAW', 'STREAM_DRAW'
	]