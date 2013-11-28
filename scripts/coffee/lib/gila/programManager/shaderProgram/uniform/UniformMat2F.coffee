_MatrixUniform = require './_MatrixUniform'

module.exports = class UniformMat2F extends _MatrixUniform

	constructor: ->

		@_len = 4

		super

	_set: (mat, transpose) ->

		@gl.uniformMatrix2fv @location, transpose, mat

		return