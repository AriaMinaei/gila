ImageTexture = require './texture2DManager/ImageTexture'

module.exports = class Texture2DManager

	constructor: (@_gila) ->

		@_bound = null

	makeImageTexture: (source) ->

		new ImageTexture @, source