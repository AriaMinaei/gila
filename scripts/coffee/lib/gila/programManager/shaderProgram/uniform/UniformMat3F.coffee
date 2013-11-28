_MatrixUniform = require './_MatrixUniform'

module.exports = class UniformMat3F extends _MatrixUniform

	constructor: ->

		@_len = 9

		super

	_set: (mat, transpose) ->

		@gl.uniformMatrix3fv @location, transpose, mat

		return