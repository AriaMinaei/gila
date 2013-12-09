setupShortcuts = require './texture2D/setupShortcuts'

T2D = WebGLRenderingContext.TEXTURE_2D

{UNPACK_FLIP_Y_WEBGL} = WebGLRenderingContext

slots = for i in [0..32] then WebGLRenderingContext['TEXTURE' + i]

module.exports = class Texture2D

	constructor: (@_2DManager, source) ->

		unless source?

			throw Error "`source` cannot be empty"

		@_gila = @_2DManager._gila

		@_gl = @_gila.gl

		@_manager = @_gila._textureManager

		@_uploaded = no

		@_source = null

		@url = ''

		@_options =

			flipY: no

			hasAlpha: yes

			shouldGenerateMipmap: no

		@_params = {}

		@_format = @_gl.RGBA

		@texture = @_gl.createTexture()

		@_set source

		@_slot = -1

		do @magnifyWithLinear

		do @minifyWithNearest

	bind: ->

		unless @_2DManager._bound is @

			@_gl.bindTexture T2D, @texture

			@_2DManager._bound = @

		@

	isUploaded: ->

		@_uploaded

	withAlpha: ->

		if @_uploaded

			throw Error "The texture is already uploaded"

		@_options.hasAlpha = yes

		@_format = @_gl.RGBA

		@

	flipY: ->

		if @_uploaded

			throw Error "The texture is already uploaded"

		@_options.flipY = yes

		@

	noAlpha: ->

		if @_uploaded

			throw Error "The texture is already uploaded"

		@_options.hasAlpha = no

		@_format = @_gl.RGB

		@

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

		do @bind

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

	_setParameters: ->

		if @_options.shouldGenerateMipmap

			do @generateMipmap

		for pname, value of @_params

			@_setParameter pname, value

		return

	generateMipmap: ->

		do @bind

		@_gl.generateMipmap T2D

		@

	_setParameter: (pname, param) ->

		@_gl.texParameteri T2D, pname, param

		return

	_scheduleToSetParam: (pname, param) ->

		if @_uploaded

			throw Error "Texture is already uploaded"

		@_params[pname] = param

		return

	assignToSlot: (n) ->

		if @_gila.debug

			if not @_uploaded

				console.warn "Texture isn't loaded yet"

		@_manager.assignTextureToSlot @, n

		@

	getSlot: ->

		@_slot

setupShortcuts Texture2D