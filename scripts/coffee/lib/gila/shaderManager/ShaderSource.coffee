Shader = require './Shader'
flagsToIndex = require '../utility/flagsToIndex'

module.exports = class ShaderSource

	self = @

	@_ifdefRx: ///

		\#ifdef\s+

		([a-zA-Z0-9\_]+)

	///g

	@_ifdefRemoveRx: ///

		^\#ifdef\s+

	///

	constructor: (@_manager, @type, @id, @source) ->

		@_gila = @_manager._gila

		@_possibleFlags = self.getPossibleFlags @source

		@_variations = {}

	getVariation: (flags) ->

		unless flags

			return do @_getDefaultVariation

		index = @_getVariationIndex flags

		unless @_variations[index]

			@_variations[index] = new Shader @, @type, @id, index, @_getSourceForVariation flags

		@_variations[index]

	_getSourceForVariation: (flags) ->

		defineStatements = ''

		for flag in @_possibleFlags

			if flags[flag] is yes

				defineStatements += '#define ' + flag + '\n'

		defineStatements + @source

	_getDefaultVariation: ->

		unless @_variations[0]?

			@_variations[0] = new Shader @, @type, @id, 0, @source

		@_variations[0]

	_getVariationIndex: (flags) ->

		flagsToIndex @_possibleFlags, flags

	@getPossibleFlags: (source) ->

		flags = []

		matches = source.match self._ifdefRx

		return flags unless matches?

		for match in matches

			flag = match.replace self._ifdefRemoveRx, ''

			if flags.indexOf(flag) is -1

				flags.push flag

		flags