_NonMatrixFloatUniform = require './_NonMatrixFloatUniform'

module.exports = class Uniform4F extends _NonMatrixFloatUniform

	constructor: ->

		@_len = 4

		super

	_set: (x, y, z, w) ->

		@gl.uniform4f @location, x, y, z, w

		return

	_fromArray: (r) ->

		@gl.uniform4fv @location, r

		return