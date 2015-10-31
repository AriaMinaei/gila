_NonMatrixUniform = require './_NonMatrixUniform'

module.exports = class _NonMatrixFloatUniform extends _NonMatrixUniform
	constructor: ->
		@_arrayType = Float32Array
		super

	_singleArgumentIsValid: (val) ->
		parseFloat(val) is val