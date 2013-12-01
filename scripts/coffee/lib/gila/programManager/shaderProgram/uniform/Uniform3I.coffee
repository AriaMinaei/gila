_NonMatrixIntUniform = require './_NonMatrixIntUniform'

module.exports = class Uniform3I extends _NonMatrixIntUniform

	constructor: ->

		@_len = 3

		super

	_set: (x, y, z) ->

		@_gl.uniform3i @location, x, y, z

		return

	_fromArray: (r) ->

		@_gl.uniform3iv @location, r

		return