Texture2D = require './Texture2D'

module.exports = class EmptyTexture extends Texture2D

	constructor: (manager) ->

		super

	prepareForDims: (width, height) ->

		do @activateUnit

		@_gl.texImage2D T2D,

			# the mipmap level
			0,

			# internal format
			@_format,

			# dims
			width, height,

			# border
			0,

			# format
			@_format,

			# type of texture data
			@_gl.UNSIGNED_BYTE,

			# pixels
			null

		@uploaded = yes

		@_emit 'upload'

		@

T2D = WebGLRenderingContext.TEXTURE_2D