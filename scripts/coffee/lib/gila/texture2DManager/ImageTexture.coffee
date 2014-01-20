Texture2D = require './Texture2D'

module.exports = class ImageTexture extends Texture2D

	constructor: (manager, source) ->

		super

		unless source?

			throw Error "`source` cannot be empty"

		@_uploaded = no

		@_source = null

		@url = ''

		@_set source

	isUploaded: ->

		@_uploaded

	_fromUrl: (url) ->

		if url.length is 0

			throw Error "Texture url is empty"

		el = new Image

		el.src = url

		@_fromImage el

	_fromImage: (el) ->

		@_uploaded = no

		@_source = el

		@url = el.src

		@_source.addEventListener 'load', =>

			if @_uploaded

				throw Error "load event is fired on source element, yet the texture is already uploaded"

			do @_upload

			return

		@

	_fromNull: ->

		setTimeout =>

			do @_upload

		, 0

		return

	_set: (source) ->

		if typeof source is 'string'

			return @_fromUrl source

		else if source instanceof HTMLImageElement

			return @_fromImage source

		else if source is null

			do @_fromNull

		else

			throw Error "Only images/urls/null are supported for now"

	_upload: ->

		do @activateUnit

		@_gl.pixelStorei UNPACK_FLIP_Y_WEBGL, @_options.flipY

		@_gl.texImage2D T2D,

			# the mipmap level
			0,

			# Internal/source format
			@_format, @_format,

			# type of texture data
			@_gl.UNSIGNED_BYTE,

			# the image itself
			@_source

		do @_setParameters

		if @_source?

			@_uploaded = yes

		return

T2D = WebGLRenderingContext.TEXTURE_2D
{UNPACK_FLIP_Y_WEBGL} = WebGLRenderingContext