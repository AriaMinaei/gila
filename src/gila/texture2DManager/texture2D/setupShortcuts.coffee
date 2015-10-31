string = require '../../utility/string'

module.exports = (Texture2D) ->
	normalSetter = (funcName, pname, value) ->
		Texture2D::[funcName] = ->
			@_setParam pname, value
			this

		return

	setupMethodShortcut 'wrapS', 'TEXTURE_WRAP_S',
		['CLAMP_TO_EDGE', 'REPEAT', 'MIRRORED_REPEAT'], normalSetter

	setupMethodShortcut 'wrapT', 'TEXTURE_WRAP_T',
		['CLAMP_TO_EDGE', 'REPEAT', 'MIRRORED_REPEAT'], normalSetter

	setupMethodShortcut 'magnifyWith', 'TEXTURE_MAG_FILTER',
		['NEAREST', 'LINEAR'], normalSetter

	setupMethodShortcut 'minifyWith', 'TEXTURE_MIN_FILTER',
		['NEAREST', 'LINEAR'], normalSetter

	setupMethodShortcut 'minifyWith', 'TEXTURE_MIN_FILTER',
		[
			'NEAREST_MIPMAP_NEAREST', 'LINEAR_MIPMAP_NEAREST',
			'NEAREST_MIPMAP_LINEAR', 'LINEAR_MIPMAP_LINEAR'
		],

		(funcName, pname, value) ->
			Texture2D::[funcName] = ->
				do @generateMipmap
				@_setParam pname, value
				this

			return

setupMethodShortcut = (funcPrefix, firstArg, secondArgs, cb) ->
	firstArg = WebGLRenderingContext[firstArg]
	for arg in secondArgs
		funcName = funcPrefix + string.allUpperCaseToCamelCase(arg)
		cb funcName, firstArg, WebGLRenderingContext[arg]

	return