BlendShortcutList = require './blendManager/BlendShortcutList'

module.exports = class BlendManager
	constructor: (@_drawingManager) ->
		@_gila = @_drawingManager._gila
		@_gl = @_gila.gl
		@_shouldUpdate = no
		@_type = TOGETHER

		@src = new BlendShortcutList @, TOGETHER
		@dst = new BlendShortcutList @, TOGETHER
		@srcRgb = new BlendShortcutList @, SEPARATE
		@dstRgb = new BlendShortcutList @, SEPARATE
		@srcAlpha = new BlendShortcutList @, SEPARATE
		@dstAlpha = new BlendShortcutList @, SEPARATE

		do @_reset

	_reset: ->
		@src._factor = ONE
		@dst._factor = ZERO
		@srcRgb._factor = ONE
		@srcAlpha._factor = ONE
		@dstRgb._factor = ZERO
		@dstAlpha._factor = ZERO

	reset: ->
		do @_reset
		@_shouldUpdate = yes

		this

	_setType: (type) ->
		if @_type isnt type
			@_type = type
			do @reset

		return

	update: ->
		do @_apply

	_apply: ->
		return unless @_shouldUpdate
		@_shouldUpdate = no

		if @_type is TOGETHER
			@_gl.blendFunc @src._factor, @dst._factor
		else
			@_gl.blendFuncSeparate @srcRgb._factor,
				@dstRgb._factor, @srcAlpha._factor,
				@dstAlpha._factor

		return

[TOGETHER, SEPARATE] = [0, 1]
{ZERO, ONE} = WebGLRenderingContext