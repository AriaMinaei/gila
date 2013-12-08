Texture2D = require './texture2DManager/Texture2D'

module.exports = class Texture2DManager

	constructor: (@_gila) ->

		@_bound = null

	makeTexture: (source) ->

		new Texture2D @, source