_NonMatrixUniform = require './_NonMatrixUniform'

module.exports = class _NonMatrixFloatUniform extends _NonMatrixUniform

	_singleArgumentIsValid: (val) ->

		parseFloat(val) is val