_Uniform = require '../_Uniform'

module.exports = class _MatrixUniform extends _Uniform

	constructor: ->

		super

	set: (mat, transpose = no) ->

		if @gila.debug

			unless mat instanceof Float32Array

				throw Error "Matrix must be a Float32Array"

			unless mat.length is @_len

				throw Error "Matrix's length must equal to '@{len}'. Given: '#{mat.length}'"

			if Boolean(transpose) isnt transpose

				throw Error "transpose must be a boolean. Given: `#{typeof transpose}`"

		@_set mat, transpose