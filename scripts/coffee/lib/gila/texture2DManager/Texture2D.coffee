setupShortcuts = require './texture2D/setupShortcuts'
_Emitter = require '../utility/_Emitter'

module.exports = class Texture2D extends _Emitter

	constructor: (@_2DManager) ->

		super

		@_gila = @_2DManager._gila

		@_gl = @_gila.gl

		@_manager = @_gila._textureManager

		@_options =

			flipY: no

			hasAlpha: yes

		@_shouldGenerateMipmap = no

		@_params = {}

		@_format = @_gl.RGBA

		@_uploaded = no

		@texture = @_gl.createTexture()

		@_unit = -1

		@_unitIsLocked = no

		do @magnifyWithLinear

		do @minifyWithLinear

	isUploaded: ->

		@_uploaded

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

	generateMipmap: ->

		return @ if @_shouldGenerateMipmap

		@_shouldGenerateMipmap = yes

		@on 'upload', =>

			@_generateMipmap()

		if @_uploaded

			do @_generateMipmap

		return

	_generateMipmap: ->

		do @bind

		@_gl.generateMipmap T2D

		@

	_setParam: (pname, param) ->

		do @bind

		@_params[pname] = param

		@_gl.texParameteri T2D, pname, param

		return

T2D = WebGLRenderingContext.TEXTURE_2D
setupShortcuts Texture2D