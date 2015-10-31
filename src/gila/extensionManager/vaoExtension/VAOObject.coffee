module.exports = class VAOObject

	constructor: (@_extension, @_obj) ->

	isBound: ->
		@_extension._bound is @

	bind: ->
		@_extension._bind @
		this

	unbind: ->
		@_extension.unbind()
		this