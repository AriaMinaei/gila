ShaderProgram = require './programManager/ShaderProgram'

module.exports = class ProgramManager

	constructor: (@_gila) ->

		@_gl = @_gila.gl

		@_active = null

	makeProgram: (vertexSource, fragmentSource, id) ->

		new ShaderProgram @, vertexSource, fragmentSource, id