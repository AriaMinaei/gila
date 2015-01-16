module.exports = class FrameBuffer

	constructor: (@manager) ->

		@_gila = @manager._gila

		@_gl = @_gila.gl

		@_fb = @_gl.createFramebuffer()

		@dims = new Float32Array @_gila.viewportSize

		@_colorTexture = null

		@_depthRenderBuffer = null

	isBound: ->

		@manager._bound is @

	bind: ->

		@manager._bound = @

		@_gl.bindFramebuffer @_gl.FRAMEBUFFER, @_fb

		@

	unbind: ->

		if @isBound()

			@manager._bound = null

			@_gl.bindFramebuffer @_gl.FRAMEBUFFER, null

		@

	makeTextureForColor: ->

		@_gila.makeEmptyTexture()
		.prepareForDims(@dims[0], @dims[1])
		.wrapSClampToEdge()
		.wrapTClampToEdge()

	useTextureForColor: (t) ->

		if @_gila.debug and not @isBound()

			throw Error "FrameBuffer is not bound"

		t = @makeTextureForColor() unless t?

		@_colorTexture = t

		@_gl.framebufferTexture2D @_gl.FRAMEBUFFER,

			@_gl.COLOR_ATTACHMENT0, @_gl.TEXTURE_2D, t.texture, 0

		@

	getColorTexture: ->

		@_colorTexture

	hasColorTexture: ->

		@_colorTexture?

	makeRenderBufferForDepth: ->

		@_gila.makeRenderBuffer().storeDepth16(@dims[0], @dims[1])

	useRenderBufferForDepth: (b) ->

		if @_gila.debug and not @isBound()

			throw Error "FrameBuffer is not bound"

		b = @makeRenderBufferForDepth() unless b?

		@_depthRenderBuffer = b

		@_gl.framebufferRenderbuffer @_gl.FRAMEBUFFER,

			@_gl.DEPTH_ATTACHMENT, @_gl.RENDERBUFFER, b.buffer

		@

	getDepthRenderBuffer: ->

		@_depthRenderBuffer

	hasDepthRenderBuffer: ->

		@_depthRenderBuffer?