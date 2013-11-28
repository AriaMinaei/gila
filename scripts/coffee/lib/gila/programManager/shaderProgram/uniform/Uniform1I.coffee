_NonMatrixIntUniform = require './_NonMatrixIntUniform'

module.exports = class Uniform1I extends _NonMatrixIntUniform

	constructor: ->

		@_len = 1

		super

	_set: (x) ->

		@gl.uniform1i @location, x

		return

	_fromArray: (r) ->

		@gl.uniform1iv @location, r

		return