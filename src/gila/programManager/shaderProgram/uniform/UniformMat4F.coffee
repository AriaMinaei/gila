_MatrixUniform = require './_MatrixUniform'

module.exports = class UniformMat4F extends _MatrixUniform
	constructor: ->
		@_len = 16
		super

	_set: (mat) ->
		@_gl.uniformMatrix4fv @location, no, mat
		return