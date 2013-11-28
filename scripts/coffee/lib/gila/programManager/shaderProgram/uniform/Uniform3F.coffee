_NonMatrixFloatUniform = require './_NonMatrixFloatUniform'

module.exports = class Uniform3F extends _NonMatrixFloatUniform

	constructor: ->

		@_len = 3

		super

	_set: (x, y, z) ->

		@gl.uniform3f @location, x, y, z

		return

	_fromArray: (r) ->

		@gl.uniform3fv @location, r

		return