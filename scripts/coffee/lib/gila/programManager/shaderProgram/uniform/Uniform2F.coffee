_NonMatrixFloatUniform = require './_NonMatrixFloatUniform'

module.exports = class Uniform2F extends _NonMatrixFloatUniform

	constructor: ->

		@_len = 2

		super

	_set: (x, y) ->

		@gl.uniform2f @location, x, y

		return