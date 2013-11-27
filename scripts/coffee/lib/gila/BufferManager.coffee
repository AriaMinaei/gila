Buffer = require './bufferManager/Buffer'

module.exports = class BufferManager

	constructor: (@gila) ->

		@gl = @gila.gl

		@_bound = null

	_makeBuffer: (type, usage) ->

		new Buffer @, type, usage

	makeArrayBuffer: (usage) ->

		@_makeBuffer @gl.ARRAY_BUFFER, usage

	makeElementArrayBuffer: (usage) ->

		@_makeBuffer @gl.ELEMENT_ARRAY_BUFFER, usage