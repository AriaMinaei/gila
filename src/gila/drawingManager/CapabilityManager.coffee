Capability = require './capabilityManager/Capability'

module.exports = class CapabilityManager
	constructor: (@_drawingManager) ->
		@_gl = @_drawingManager._gila.gl

		@blending = new Capability @, BLEND, 0
		@faceCulling = new Capability @, CULL_FACE, 0
		@depthTesting = new Capability @, DEPTH_TEST, 0
		@scissorTesting = new Capability @, SCISSOR_TEST, 0
		@polygonOffsetFilling = new Capability @, POLYGON_OFFSET_FILL, 0

	_enable: (capability) ->
		@_gl.enable capability
		return

	_disable: (capability) ->
		@_gl.disable capability
		return

	@_propsToExpose: [
		'blending', 'faceCulling', 'depthTesting',
		'scissorTesting', 'polygonOffsetFilling'
	]

	@_memberName: '_capabilityManager'

{BLEND, CULL_FACE, DEPTH_TEST, SCISSOR_TEST, POLYGON_OFFSET_FILL} = WebGLRenderingContext