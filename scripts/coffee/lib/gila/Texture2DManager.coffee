Texture2D = require './texture2DManager/Texture2D'

module.exports = class Texture2DManager

	constructor: (@gila) ->

		@gl = @gila.gl

		@_state = {}

		@setPixelStorageFlipping yes

		@_bound = null

	setPixelStorageFlipping: (flip = yes) ->

		@_state.flipPixelStorage = Boolean flip

		@gl.pixelStorei @gl.UNPACK_FLIP_Y_WEBGL, @_state.flipPixelStorage

		@

	makeTexture: (source) ->

		new Texture2D @, source