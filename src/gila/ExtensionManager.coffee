VAOExtension = require './extensionManager/VAOExtension'

module.exports = class ExtensionManager
	constructor: (@_gila) ->
		@_gl = @_gila.gl
		@vao = new VAOExtension @