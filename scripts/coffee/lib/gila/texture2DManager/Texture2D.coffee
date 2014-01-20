setupShortcuts = require './texture2D/setupShortcuts'

module.exports = class Texture2D

	constructor: (@_2DManager) ->

		@_gila = @_2DManager._gila

		@_gl = @_gila.gl

		@_manager = @_gila._textureManager

		@_options =

			flipY: no

			hasAlpha: yes

			shouldGenerateMipmap: no

		@_params = {}

		@_format = @_gl.RGBA

		@texture = @_gl.createTexture()

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

T2D = WebGLRenderingContext.TEXTURE_2D
units = for i in [0..32] then WebGLRenderingContext['TEXTURE' + i]
setupShortcuts Texture2D