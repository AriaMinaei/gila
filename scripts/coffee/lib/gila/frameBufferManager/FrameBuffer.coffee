module.exports = class FrameBuffer

	constructor: (@manager) ->

		@_gila = @manager._gila

		@_gl = @_gila.gl

		@_fb = @_gl.createFramebuffer()

		@dims = new Float32Array 2
		@dims[0] = @_gila._viewportArea[2]
		@dims[1] = @_gila._viewportArea[3]

	isBound: ->

		@manager.bound is @

	bind: ->

		@manager.bound = @

		@_gl.bindFramebuffer @_gl.FRAMEBUFFER, @_fb

		@