setupShortcuts = require './texture2D/setupShortcuts'

T2D = WebGLRenderingContext.TEXTURE_2D

slots = for i in [0..32] then WebGLRenderingContext['TEXTURE' + i]

module.exports = class Texture2D

	constructor: (@_manager, source) ->

		unless source?

			throw Error "`source` cannot be empty"

		@gila = @_manager.gila

		@gl = @gila.gl

		@_uploaded = no

		@_source = null

		@_options =

			flipY: yes

			hasAlpha: yes

			shouldGenerateMipmap: no

		@_params = {}

		@_format = @gl.RGBA

		@texture = @gl.createTexture()

		@_set source

		do @magnifyWithLinear

		do @minifyWithNearest

	bind: ->

		unless @_manager._bound is @

			@gl.bindTexture T2D, @texture

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

	_fromUrl: (url) ->

		if url.length is 0

			throw Error "Texture url is empty"

		el = new Image

		el.src = url

		@_fromImage el

	_fromImage: (el) ->

		@_uploaded = no

		@_source = el

		@_source.addEventListener 'load', =>

			if @_uploaded

				throw Error "load event is fired on source element, yet the texture is already uploaded"

			do @_upload

			return

		@

	_set: (source) ->

		if typeof source is 'string'

			return @_fromUrl source

		else if source instanceof HTMLImageElement

			return @_fromImage source

		else

			throw Error "Only images or urls to images are supported for now"

	_upload: ->

		do @bind

		@gl.texImage2D T2D,

			# the mipmap level
			0,

			# Internal/source format
			@_format, @_format,

			# type of texture data
			@gl.UNSIGNED_BYTE,

			# the image itself
			@_source

		do @_setParameters

		@_uploaded = yes

	_setParameters: ->

		if @_options.shouldGenerateMipmap

			@gl.generateMipmap T2D

		for pname, value of @_params

			@_setParameter pname, value

		return

	_setParameter: (pname, param) ->

		@gl.texParameteri T2D, pname, param

		return

	_scheduleToSetParam: (pname, param) ->

		if @_uploaded

			throw Error "Texture is already uploaded"

		@_params[pname] = param

		return

	assignToSlot: (n) ->

		n = parseInt n

		if @gila.debug

			if not @_uploaded

				console.warn "Texture isn't loaded yet"

			if not (0 <= n <= 31)

				throw Error "n out of range: `#{n}`"

		@gl.activeTexture slots[n]

		do @bind

		@

setupShortcuts Texture2D