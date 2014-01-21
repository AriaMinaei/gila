ImageTexture = require './texture2DManager/ImageTexture'
EmptyTexture = require './texture2DManager/EmptyTexture'

module.exports = class Texture2DManager

	constructor: (@_gila) ->

		@_bound = null

	makeImageTexture: (source) ->

		new ImageTexture @, source

	makeEmptyTexture: (source) ->

		new EmptyTexture @, source