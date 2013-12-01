_NonMatrixIntUniform = require './_NonMatrixIntUniform'

module.exports = class Uniform2I extends _NonMatrixIntUniform

	constructor: ->

		@_len = 2

		super

	_set: (x, y) ->

		@_gl.uniform2i @location, x, y

		return

	_fromArray: (r) ->

		@_gl.uniform2iv @location, r

		return