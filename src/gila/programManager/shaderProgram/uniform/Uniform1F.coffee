_NonMatrixFloatUniform = require './_NonMatrixFloatUniform'

module.exports = class Uniform1F extends _NonMatrixFloatUniform

	constructor: ->

		@_len = 1

		super

	_set: (x) ->

		@_gl.uniform1f @location, x

		return

	_fromArray: (r) ->

		@_gl.uniform1fv @location, r

		return