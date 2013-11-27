_NonMatrixFloatUniform = require './_NonMatrixFloatUniform'

module.exports = class Uniform1F extends _NonMatrixFloatUniform

	constructor: ->

		@_len = 1

		super

	_set: (x) ->

		@gl.uniform1f @location, x

		return