module.exports = class _Buffer

	self = @

	constructor: (@_manager) ->

		@_gila = @_manager._gila

		@_gl = @_gila.gl

		@buffer = @_gl.createBuffer()

	_data: (data, usage) ->

		do @bind

		@_gl.bufferData @_type, data, usage

		@

	staticData: (data) ->

		@_data data, STATIC_DRAW

	dynamicData: (data) ->

		@_data data, DYNAMIC_DRAW

	streamData: (data) ->

		@_data data, STREAM_DRAW

	data: (data) ->

		@staticData data

{STATIC_DRAW, DYNAMIC_DRAW, STREAM_DRAW} = WebGLRenderingContext