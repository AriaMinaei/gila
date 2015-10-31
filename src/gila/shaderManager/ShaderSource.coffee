Shader = require './Shader'
OptionsToIndex = require 'options-to-index'

module.exports = class ShaderSource
	self = @

	@_ifdefRx: ///
		\#ifdef\s+
		([a-zA-Z0-9\_]+)
	///g

	@_ifdefRemoveRx: ///
		^\#ifdef\s+
	///

	@_ifDefinedRx: ///
		\#.*
		defined\(([a-zA-Z0-9\_]+)\)
	///g

	@_definedRx: ///
		(defined\()
		([a-zA-Z0-9\_]+)
		(\))
	///g

	constructor: (@_manager, @type, @id, @source) ->
		@_gila = @_manager._gila
		@_template = self.getTemplateFor @source

		# note: this is not tested
		@_optionsToIndex = new OptionsToIndex @_template
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
		for flag of @_template
			if flags[flag] is yes
				defineStatements += '#define ' + flag + '\n'

		defineStatements + @source

	_getDefaultVariation: ->
		unless @_variations[0]?
			@_variations[0] = new Shader @, @type, @id, 0, @source

		@_variations[0]

	_getVariationIndex: (flags) ->
		@_optionsToIndex.getIndex flags

	@getTemplateFor: (source) ->
		template = {}
		matches = source.match self._ifdefRx
		return template unless matches?
		for match in matches
			flag = match.replace self._ifdefRemoveRx, ''
			template[flag] = null

		matches = source.match self._ifDefinedRx
		for match in matches
			for definedStatement in match.match self._definedRx
				flag = definedStatement.substr 8, definedStatement.length - 9
				template[flag] = null

		template