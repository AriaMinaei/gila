VAOObject = require './vaoExtension/VAOObject'

module.exports = class VAOExtension
	constructor: (@_manager) ->
		@_gila = @_manager._gila
		@_gl = @_gila.gl
		@_ext = @_gl.getExtension('OES_vertex_array_object')
		@_available = @_ext?
		@_bound = null

	isAvailable: ->
		@_available

	unbind: ->
		@_bound = null
		@_ext.bindVertexArrayOES null
		this

	create: ->
		new VAOObject @, @_ext.createVertexArrayOES()

	_bind: (obj) ->
		return if obj is @_bound
		@_bound = obj
		@_ext.bindVertexArrayOES obj._obj
		return