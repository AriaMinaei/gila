_Uniform = require '../_Uniform'

argNames = ['x', 'y', 'z', 'w']

module.exports = class _NonMatrixUniform extends _Uniform

	constructor: ->

		super

	set: ->

		if @gila.debug

			for i in [0...@_len]

				@_validateSingleArgument arguments[i], i

		@_set.apply @, arguments

	_validateSingleArgument: (val, i) ->

		argName = argNames[i]

		unless @_singleArgumentIsValid val

			throw Error "Invalid value for `#{argName}`. Given: '#{val}'"