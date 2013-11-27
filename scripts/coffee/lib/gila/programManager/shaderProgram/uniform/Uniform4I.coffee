_NonMatrixIntUniform = require './_NonMatrixIntUniform'

module.exports = class Uniform4I extends _NonMatrixIntUniform

	constructor: ->

		@_len = 4

		super

	_set: (x, y, z, w) ->

		@gl.uniform4i @location, x, y, z, w

		return