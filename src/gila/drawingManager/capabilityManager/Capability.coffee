module.exports = class Capability

	constructor: (@_manager, @_prop, @_default) ->
		@_current = @_default

	get: ->
		@_current

	enable: ->
		if @_current is 0
			@_manager._enable @_prop
			@_current = 1

		1

	disable: ->
		if @_current is 1
			@_manager._disable @_prop
			@_current = 0

		0

	reset: ->
		return if @_current is @_default

		if @_default is 1
			return do @enable
		else
			return do @disable