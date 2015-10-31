RenderBuffer = require './renderBufferManager/RenderBuffer'

module.exports = class RenderBufferManager
	constructor: (@_gila) ->
		@_bound = null

	make: ->
		new RenderBuffer @