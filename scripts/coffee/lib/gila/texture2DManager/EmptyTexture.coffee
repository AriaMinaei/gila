Texture2D = require './Texture2D'

module.exports = class EmptyTexture extends Texture2D

	constructor: (manager) ->

		super

	prepareForDims: (width, height) ->

		do @activateUnit

		@_gl.texImage2D T2D,

			# the mipmap level
			0,

			@_format,

			# dims
			width, height,

			0,

			@_format,

			# type of texture data
			@_gl.UNSIGNED_BYTE,

			null

		do @_setParameters

		@_uploaded = yes

		@

T2D = WebGLRenderingContext.TEXTURE_2D