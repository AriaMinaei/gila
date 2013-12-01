string = require '../../utility/string'

module.exports = class BlendShortcutList

	constructor: (@_manager, @_type, @_factor) ->

factorNames = [
	'ZERO', 'ONE', 'SRC_COLOR', 'ONE_MINUS_SRC_COLOR', 'DST_COLOR',
	'ONE_MINUS_DST_COLOR', 'SRC_ALPHA', 'ONE_MINUS_SRC_ALPHA', 'DST_ALPHA',
	'ONE_MINUS_DST_ALPHA', 'SRC_ALPHA_SATURATE'
]

for name in factorNames

	funcName = string.allUpperCaseToCamelCase(name)

	funcName = funcName[0].toLowerCase() + funcName.substr(1, funcName.length)

	do ->

		factor = WebGLRenderingContext[name]

		BlendShortcutList::[funcName] = ->

			@_manager._setType @_type

			if @_factor isnt factor

				@_factor = factor

				@_manager._shouldUpdate = yes

			@_manager