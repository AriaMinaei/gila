_NonMatrixUniform = require './_NonMatrixUniform'

module.exports = class _NonMatrixIntUniform extends _NonMatrixUniform

	_singleArgumentIsValid: (val) ->

		parseInt(val) is val