setupShortcuts = require './texture2D/setupShortcuts'

T2D = WebGLRenderingContext.TEXTURE_2D

{UNPACK_FLIP_Y_WEBGL} = WebGLRenderingContext

units = for i in [0..32] then WebGLRenderingContext['TEXTURE' + i]

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

		@_unit = -1

		@_unitIsLocked = no

		do @magnifyWithLinear

		do @minifyWithNearest

	bind: ->

		unless @_2DManager._bound is @

			@_gl.bindTexture T2D, @texture

			@_2DManager._bound = @

		@

	unbind: ->

		if @_2DManager._bound is @

			@_gl.bindTexture T2D, null

			@_2DManager._bound = null

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

		if @_gila.debug and @_uploaded

			throw Error "The texture is already uploaded"

		@_options.flipY = yes

		@

	noAlpha: ->

		if @_gila.debug and @_uploaded

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

	_setParameters: ->

		if @_options.shouldGenerateMipmap

			do @generateMipmap

		for pname, value of @_params

			@_setParameter pname, value

		return

	generateMipmap: ->

		do @activateUnit

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

	assignToUnit: (n) ->

		@_manager.assignTextureToUnit @, n

		do @activateUnit

		@

	assignToAUnit: ->

		@_manager.assignTextureToAUnit @

		do @_activateUnit

		@_unit

	activateUnit: ->

		do @assignToAUnit

		do @_activateUnit

		@

	_activateUnit: ->

		@_manager.activateUnit @_unit

		do @bind

		return

	lockUnit: ->

		@_unitIsLocked = yes

		@

	unlockUnit: ->

		@_unitIsLocked = no

		@

	isUnitLocked: ->

		@_unitIsLocked

	getUnit: ->

		if @_unit is -1 then null else @_unit

	isAssignedToUnit: ->

		@_unit isnt -1

setupShortcuts Texture2D