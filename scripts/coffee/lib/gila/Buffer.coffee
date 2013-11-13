module.exports = class Buffer

	self = @

	constructor: (@gila, @type = 'ARRAY_BUFFER', @usage = 'STATIC_DRAW') ->

		@gl = @gila.gl

		if @gila.debug and self._allowedTypes.indexOf(@type) < 0

			throw Error "Unkown bufffer type: `#{@type}"

		@_type = @gl[@type]

		if @gila.debug and self._allowedUsages.indexOf(@usage) < 0

			throw Error "Unkown buffer usage type: `#{@usage}`"

		@_usage = @gl[@usage]

		@buffer = @gl.createBuffer()

	bind: ->

		@gl.bindBuffer @_type, @buffer

		@

	data: (data, usage = @_usage) ->

		do @bind

		@gl.bufferData @_type, data, usage

		@

	@_allowedTypes: [
		'ARRAY_BUFFER', 'ELEMENT_ARRAY_BUFFER'
	]

	@_allowedUsages: [
		'STATIC_DRAW', 'DYNAMIC_DRAW', 'STREAM_DRAW'
	]