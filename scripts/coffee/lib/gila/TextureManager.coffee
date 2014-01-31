_Emitter = require './utility/_Emitter'
array = require 'utila/scripts/js/lib/array'

stupidCounter = -1
unitEnums = for i in [0...32] then WebGLRenderingContext['TEXTURE' + i]

module.exports = class TextureManager extends _Emitter

	constructor: (@_gila) ->

		super

		@_gl = @_gila.gl

		@_maxUnits = @_gila.param.maxCombinedTextureImageUnits

		@_units = []

		for i in [0...@_maxUnits]

			@_units.push

				texture: null

				assignTime: -1

		@activeUnit = 0

		@_texturesQueuedForUpload = 0

		@isReady = yes

	_assignTextureToUnit: (texture, n) ->

		return if texture._unit is n

		if @_gila.debug

			if n isnt parseInt n

				throw Error "n must be an integer"

			unless 0 <= n < @_maxUnits

				throw Error "n out of range: `#{n}`"

		unit = @_units[n]

		if oldTexture = unit.texture and oldTexture?

			if@_gila.debug and oldTexture.isUnitLocked()

				throw Error "Cannot assign texture to unit `#{n}` because this unit is locked on another texture"

			oldTexture._unit = -1

		if prevUnit = texture.getUnit()

			@_units[prevUnit].texture = null

		@_units[n].texture = texture

		@_units[n].assignTime = stupidCounter++

		texture._unit = n

		@

	_assignTextureToAUnit: (texture) ->

		return if texture.isAssignedToUnit()

		smallestAssignTime = -1

		candidateUnit = -1

		for unit, n in @_units

			if not unit.texture?

				candidateUnit = n

				break

			else if unit.texture.isUnitLocked()

				continue

			else

				if smallestAssignTime is -1 or unit.assignTime < smallestAssignTime

					smallestAssignTime = unit.assignTime

					candidateUnit = n

		if candidateUnit is -1

			throw Error "All texture units are assigned and locked"

		@_assignTextureToUnit texture, candidateUnit

		return

	_activateUnit: (n) ->

		return if @activeUnit is n

		@activeUnit = n

		@_gl.activeTexture unitEnums[n]

		return

	_waitForTexture: (t) ->

		@_texturesQueuedForUpload++

		@isReady = no

		@_emit 'not-ready'
		@_emit 'ready-state-change'

		return

	_textureIsDoneLoading: (t) ->

		@_texturesQueuedForUpload--

		if @_texturesQueuedForUpload is 0

			@isReady = yes

			@_emit 'ready'
			@_emit 'ready-state-change'

		return