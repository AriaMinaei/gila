FrameBuffer = require './frameBufferManager/FrameBuffer'

module.exports = class FrameBufferManager
	constructor: (@_gila) ->
		@_bound = null

	make: ->
		new FrameBuffer @