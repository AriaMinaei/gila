_Uniform = require '../_Uniform'

argNames = ['x', 'y', 'z', 'w']

module.exports = class _NonMatrixUniform extends _Uniform

	set: ->

		if @_gila.debug

			for i in [0...@_len]

				@_validateSingleArgument arguments[i], i

		@_set.apply @, arguments

	fromArray: (r) ->

		if @_gila.debug

			unless r instanceof @_arrayType

				throw Error "Array must be a `#{@_arrayType.name}`"

			if r.length isnt @_len

				throw Error "Array length must be equal to '#{@_len}'. Given: '#{r.length}'"

		@_fromArray r

	_validateSingleArgument: (val, i) ->

		argName = argNames[i]

		unless @_singleArgumentIsValid val

			throw Error "Invalid value for `#{argName}`. Given: '#{val}'"