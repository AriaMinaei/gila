_MatrixUniform = require './_MatrixUniform'

module.exports = class UniformMat3F extends _MatrixUniform

	constructor: ->

		@_len = 9

		super

	_set: (mat) ->

		@_gl.uniformMatrix3fv @location, no, mat

		return