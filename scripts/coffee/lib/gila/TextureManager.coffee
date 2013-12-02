slotEnums = for i in [0..32] then WebGLRenderingContext['TEXTURE' + i]

module.exports = class TextureManager

	constructor: (@_gila) ->

		@_gl = @_gila.gl

		@_maxSlots = @_gila.param.maxCombinedTextureImageUnits

		@_slots = {}

	assignTextureToSlot: (texture, n) ->

		return if texture._slot is n

		if @_gila.debug

			if n isnt parseInt n

				throw Error "n must be an integer"

			if not (0 <= n <= @_maxSlots)

				throw Error "n out of range: `#{n}`"

		oldTexture = @_slots[n]

		if oldTexture?

			oldTexture._slot = -1

		@_slots[n] = texture

		texture._slot = n

		@_gl.activeTexture slotEnums[n]

		do texture.bind

		@