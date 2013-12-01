[TOGETHER, SEPARATE] = [0, 1]
{ZERO, ONE} = WebGLRenderingContext

BlendingShortcutList = require './blendingManager/BlendingShortcutList'

module.exports = class BlendingManager

	constructor: (@_drawingManager) ->

		@gila = @_drawingManager.gila

		@gl = @gila.gl

		@_shouldUpdate = no

		@_type = TOGETHER

		@src = new BlendingShortcutList @, TOGETHER
		@dst = new BlendingShortcutList @, TOGETHER
		@srcRgb = new BlendingShortcutList @, SEPARATE
		@dstRgb = new BlendingShortcutList @, SEPARATE
		@srcAlpha = new BlendingShortcutList @, SEPARATE
		@dstAlpha = new BlendingShortcutList @, SEPARATE

		do @_reset

	_reset: ->

		@src._factor = ONE
		@dst._factor = ZERO
		@srcRgb._factor = ONE
		@srcAlpha._factor = ONE
		@dstRgb._factor = ZERO
		@dstAlpha._factor = ZERO

		return

	reset: ->

		do @_reset

		@_shouldUpdate = yes

		@

	_setType: (type) ->

		if @_type isnt type

			@_type = type

			do @reset

		return

	_applyBlending: ->

		return unless @_shouldUpdate

		@_shouldUpdate = no

		if @_type is TOGETHER

			@gl.blendFunc @src._factor, @dst._factor

		else

			@gl.blendFuncSeparate @srcRgb._factor,

				@dstRgb._factor, @srcAlpha._factor,

				@dstAlpha._factor

		return