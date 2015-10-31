ShaderProgram = require './programManager/ShaderProgram'

module.exports = class ProgramManager
	constructor: (@_gila) ->
		@_shaderManager = @_gila._shaderManager
		@_active = null
		@_programs = {}

	_getVariationOfProgram: (program, flags) ->
		vertex = program.vertex.getVariation flags
		frag = program.frag.getVariation flags
		@_getProgram vertex, frag

	getProgram: (vertex, frag, id, unique = no) ->
		if @_gila.debug and (typeof vertex is 'string' or typeof frag is 'string') and not id?
			throw Error "If you're specifying the shaders with their source, you need to specify an id to be used as the id of those shaders"

		if typeof vertex is 'string'
			vertex = @_shaderManager.getVertexShader id, vertex

		if typeof frag is 'string'
			frag = @_shaderManager.getFragmentShader id, frag

		@_getProgram vertex, frag, unique

	_getProgram: (vertex, frag, unique) ->
		combinedIndex = "#{vertex.index}/#{frag.index}"
		if unique
			return new ShaderProgram @, combinedIndex, vertex, frag

		unless @_programs[combinedIndex]?
			@_programs[combinedIndex] = new ShaderProgram @, combinedIndex, vertex, frag

		@_programs[combinedIndex]