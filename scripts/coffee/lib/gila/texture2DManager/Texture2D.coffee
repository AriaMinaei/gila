module.exports = class Texture2D

	self = @

	@TYPE_UNDEFINED: 0

	@TYPE_IMAGE_ELEMENT: 1

	constructor: (@_manager, source) ->

		@gila = @_manager.gila

		@gl = @gila.gl

		@_uploaded = no

		@_sourceType = self.TYPE_UNDEFINED

		@_source = null

		@_options =

			flipY: yes

			hasAlpha: yes

			shouldGenerateMipmap: no

		@_format = @gl.RGBA

		@texture = @gl.createTexture()

		if source?

			@set source

	bind: ->

		unless @_manager._bound is @

			@gl.bindTexture @gl.TEXTURE_2D, @texture

			@_manager._bound = @

		@

	isUploaded: ->

		@_uploaded

	withAlpha: ->

		if @_uploaded

			throw Error "The texture is already uploaded"

		@_options.hasAlpha = yes

		@_format = @gl.RGBA

		@

	noAlpha: ->

		if @_uploaded

			throw Error "The texture is already uploaded"

		@_options.hasAlpha = no

		@_format = @gl.RGB

		@

	fromUrl: (url) ->

		el = new Image

		el.src = url

		@fromImage el

	fromImage: (el) ->

		@_uploaded = no

		@_sourceType = self.TYPE_IMAGE_ELEMENT

		@_source = el

		@_source.addEventListener 'load', =>

			if @_uploaded

				throw Error "load event is fired on source element, yet the texture is already uploaded"

			do @_upload

			return

		@

	set: (source) ->

		if typeof source is 'string'

			return @fromUrl source

		else if source instanceof HTMLImageElement

			return @fromImage source

		else

			throw Error "Only images or urls to images are supported for now"

	_upload: ->

		do @bind

		@gl.texImage2D @gl.TEXTURE_2D,

			# the mipmap level
			0,

			# Internal/source format
			@_format, @_format,

			# type of texture data
			@gl.UNSIGNED_BYTE,

			# the image itself
			@_source

		# @gl.generateMipmap @gl.TEXTURE_2D

		@gl.texParameteri @gl.TEXTURE_2D, @gl.TEXTURE_MAG_FILTER, @gl.LINEAR

		@gl.texParameteri @gl.TEXTURE_2D, @gl.TEXTURE_MIN_FILTER, @gl.LINEAR

		@gl.texParameteri @gl.TEXTURE_2D, @gl.TEXTURE_WRAP_S, @gl.CLAMP_TO_EDGE

		@gl.texParameteri @gl.TEXTURE_2D, @gl.TEXTURE_WRAP_T, @gl.CLAMP_TO_EDGE

		@_uploaded = yes

		return

	assignToSlot: (n) ->

		n = parseInt n

		if @gila.debug

			if not @_uploaded

				console.warn "Texture '#{@url}' is not loaded yet"

			if not (0 <= n <= 31)

				throw Error "n out of range: `#{n}`"

		slot = @gl['TEXTURE' + n]

		@gl.activeTexture slot

		do @bind

		@