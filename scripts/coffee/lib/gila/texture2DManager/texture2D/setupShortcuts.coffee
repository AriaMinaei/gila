string = require '../../utility/string'

module.exports = (Texture2D) ->

	setupMethodShortcut 'magnifyWith', 'TEXTURE_MAG_FILTER',

		['NEAREST', 'LINEAR'], (funcName, pname, value) ->

			Texture2D::[funcName] = ->

				@_scheduleToSetParam pname, value

				@

			return

	setupMethodShortcut 'minifyWith', 'TEXTURE_MIN_FILTER',

		['NEAREST', 'LINEAR'], (funcName, pname, value) ->

			Texture2D::[funcName] = ->

				@_scheduleToSetParam pname, value

				@_options.shouldGenerateMipmap = no

				@

			return

	setupMethodShortcut 'minifyWith', 'TEXTURE_MIN_FILTER',

		[
			'NEAREST_MIPMAP_NEAREST', 'LINEAR_MIPMAP_NEAREST',
			'NEAREST_MIPMAP_LINEAR', 'LINEAR_MIPMAP_LINEAR'
		],

		(funcName, pname, value) ->

			Texture2D::[funcName] = ->

				@_scheduleToSetParam pname, value

				@_options.shouldGenerateMipmap = yes

				@

			return

setupMethodShortcut = (funcPrefix, firstArg, secondArgs, cb) ->

	firstArg = WebGLRenderingContext[firstArg]

	for arg in secondArgs

		funcName = funcPrefix + string.allUpperCaseToCamelCase(arg)

		cb funcName, firstArg, WebGLRenderingContext[arg]

	return