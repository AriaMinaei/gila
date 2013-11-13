Shader = require './shaderProgram/Shader'
Uniform = require 	'./shaderProgram/Uniform'
VertexAttribute = require 	'./shaderProgram/VertexAttribute'

module.exports = class ShaderProgram

	constructor: (@gila, vertexSource, fragmentSource, @id = '') ->

		@gl = @gila.gl

		@vertexShader = @_makeShader vertexSource, 'vertex', @id

		@fragmentShader = @_makeShader fragmentSource, 'fragment', @id

		@_attribs = {}

		@_uniforms = {}

		do @_prepare

	_makeShader: (source, type) ->

		new Shader @gila, source, type

	_prepare: ->

		@program = @gl.createProgram()

		@gl.attachShader @program, @vertexShader.shader
		@gl.attachShader @program, @fragmentShader.shader
		@gl.linkProgram @program

		if @gila.debug and not @gl.getProgramParameter @program, @gl.LINK_STATUS

			throw Error "Could not initialize shader program '#{@id}'"

		return

	attrib: (name) ->

		unless @_attribs[name]?

			@_attribs[name] = new VertexAttribute @gila, @, name

		@_attribs[name]

	uniform: (name) ->

		unless @_uniforms[name]?

			@_uniforms[name] = new Uniform @gila, @, name

		@_uniforms[name]

	goInUse: ->

		@gl.useProgram @program

		@

	assignTextureSlotToUniform: (uniformName, n) ->

		n = parseInt n

		if @gila.debug and not (0 <= n <= 31)

			throw Error "n out of range: `#{n}`"

		uniform = @uniform uniformName

		@gl.uniform1i uniform.location, n

		@