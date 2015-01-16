ElementArrayBufferType = require './bufferManager/buffer/ElementArrayBufferType'
ArrayBufferType = require './bufferManager/buffer/ArrayBufferType'

module.exports = class BufferManager

	constructor: (@_gila) ->

		@_boundArrayBuffer = null

		@_boundElementArrayBuffer = null

	makeArrayBuffer: (usage) ->

		new ArrayBufferType @, usage

	makeElementArrayBuffer: (usage) ->

		new ElementArrayBufferType @, usage

	getBoundArrayBuffer: ->

		@_boundArrayBuffer

	getBoundElementArrayBuffer: ->

		@_boundElementArrayBuffer