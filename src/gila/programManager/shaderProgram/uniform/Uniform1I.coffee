_NonMatrixIntUniform = require './_NonMatrixIntUniform'

module.exports = class Uniform1I extends _NonMatrixIntUniform

	constructor: ->

		@_len = 1

		super

	_set: (x) ->

		@_gl.uniform1i @location, x

		return

	_fromArray: (r) ->

		@_gl.uniform1iv @location, r

		return