ShaderProgram = require './programManager/ShaderProgram'

module.exports = class ProgramManager

	constructor: (@gila) ->

		@gl = @gila.gl

		@_active = null

	makeProgram: (vertexSource, fragmentSource, id) ->

		new ShaderProgram @, vertexSource, fragmentSource, id