_NonMatrixUniform = require './_NonMatrixUniform'

module.exports = class _NonMatrixIntUniform extends _NonMatrixUniform

	constructor: ->

		@_arrayType = Int32Array

		super

	_singleArgumentIsValid: (val) ->

		parseInt(val) is val