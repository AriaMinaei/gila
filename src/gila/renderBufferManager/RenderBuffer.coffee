module.exports = class RenderBuffer
	constructor: (@manager) ->
		@_gila = @manager._gila
		@_gl = @_gila.gl
		@buffer = @_gl.createRenderbuffer()
		@dims = new Float32Array @_gila.viewportSize

	isBound: ->
		@manager.bound is @

	bind: ->
		@manager.bound = @
		@_gl.bindRenderbuffer @_gl.RENDERBUFFER, @buffer
		this

	_store: (format, width = @dims[0], height = @dims[1]) ->
		do @bind
		@_gl.renderbufferStorage @_gl.RENDERBUFFER, format, width, height
		this

	storeDepth16: (w, h) ->
		@_store @_gl.DEPTH_COMPONENT16, w, h