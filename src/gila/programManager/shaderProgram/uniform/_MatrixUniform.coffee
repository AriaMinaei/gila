_Uniform = require '../_Uniform'

module.exports = class _MatrixUniform extends _Uniform
	constructor: ->
		super

		unless @_gila.debug
			@set = @_set

	set: (mat) ->
		super

		unless mat instanceof Float32Array
			throw Error "Matrix must be a Float32Array"

		unless mat.length is @_len
			throw Error "Matrix's length must equal to '@{len}'. Given: '#{mat.length}'"

		@_set mat

	fromArray: (mat) ->
		@set mat