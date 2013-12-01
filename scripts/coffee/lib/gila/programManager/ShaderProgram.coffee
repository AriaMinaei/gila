Shader = require './shaderProgram/Shader'
uniforms = require './shaderProgram/uniform/index'
VertexAttribute = require 	'./shaderProgram/VertexAttribute'

module.exports = class ShaderProgram

	constructor: (@_manager, vertexSource, fragmentSource, @id = '') ->

		@_gila = @_manager._gila

		@_gl = @_gila.gl

		@vertexShader = @_makeShader vertexSource, 'vertex', @id

		@fragmentShader = @_makeShader fragmentSource, 'fragment', @id

		@_attribs = {}

		@_uniforms = {}

		do @_prepare

	isActive: ->

		@ is @_manager._active

	activate: ->

		unless @isActive()

			@_gl.useProgram @program

			@_manager._active = @

		@

	_makeShader: (source, type) ->

		new Shader @_gila, source, type

	_prepare: ->

		@program = @_gl.createProgram()

		@_gl.attachShader @program, @vertexShader.shader
		@_gl.attachShader @program, @fragmentShader.shader
		@_gl.linkProgram @program

		if @_gila.debug and not @_gl.getProgramParameter @program, @_gl.LINK_STATUS

			throw Error "Could not initialize shader program '#{@id}'"

		return

	attr: (name) ->

		unless @_attribs[name]?

			@_attribs[name] = new VertexAttribute @_gila, @, name

		@_attribs[name]

	assignTextureSlotToUniform: (uniformName, n) ->

		n = parseInt n

		if @_gila.debug and not (0 <= n <= 31)

			throw Error "n out of range: `#{n}`"

		uniform = @uniform '1i', uniformName

		uniform.set n

		@

	uniform: (type, name) ->

		unless @_uniforms[name]?

			@_uniforms[name] = @_makeUniform type, name

		else if @_gila.debug

			@_makeSureUniformTypesMatch newType, @_uniforms[name], name

		@_uniforms[name]

	_makeUniform: (type, name) ->

		cls = uniforms[type]

		if @_gila.debug and not cls?

			throw Error "Unkown uniform type `#{type}`"

		new cls @_gila, @, name

	_makeSureUniformTypesMatch: (type, uniform, name) ->

		cls = uniforms[type]

		if not cls?

			throw Error "Unkown uniform type `#{type}`"

		if cls isnt uniform.constructor

			originalType = uniforms.indexOf(uniform.constructor)

			throw Error "Uniform `#{name}` is already initialized as `#{originalType}`. Cannot re-set it to `#{type}`"

		return