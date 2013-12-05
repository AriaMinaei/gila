uniforms = require './shaderProgram/uniform/index'
VertexAttribute = require 	'./shaderProgram/VertexAttribute'

module.exports = class ShaderProgram

	constructor: (@_manager, @index, @vertex, @frag) ->

		@_gila = @_manager._gila

		@_gl = @_gila.gl

		@_attribs = {}

		@_uniforms = {}

		@program = null

		do @_prepare

	isActive: ->

		@ is @_manager._active

	activate: ->

		unless @isActive()

			@_gl.useProgram @program

			@_manager._active = @

		@

	getVariation: (flags) ->

		@_manager._getVariationOfProgram @, flags

	_prepare: ->

		@vertex.ready()
		@frag.ready()

		@program = @_gl.createProgram()

		@_gl.attachShader @program, @frag.shader
		@_gl.attachShader @program, @vertex.shader
		@_gl.linkProgram @program

		if @_gila.debug and not @_gl.getProgramParameter @program, @_gl.LINK_STATUS

			throw Error "Could not initialize shader program '#{@index}'"

		return

	attr: (name) ->

		unless @_attribs[name]?

			@_attribs[name] = new VertexAttribute @_gila, @, name

		@_attribs[name]

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