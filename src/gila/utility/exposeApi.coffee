module.exports = exposeApi = (children..., cls) ->

	for child in children

		exportApiFromSingleClass child, cls

	return

getter = (o, name, fn) ->

	Object.defineProperty o, name, {get: fn, enumerable: yes}

exportApiFromSingleClass = (child, cls) ->

	methods = child._methodsToExpose

	props = child._propsToExpose

	memberName = child._memberName

	memberNameValid = typeof memberName is 'string'

	if (props? or methods?) and not memberNameValid

		throw Error "Class `#{child}` must have a valid `_memberName` property to be able to expose methods/props"

	if methods?

		if Array.isArray methods

			exposeMethodsFromArray methods, child, cls, memberName

		else if methods is '*'

			exposeAllMethods child, cls, memberName

		else

			throw Error "Invalid value for `_methodsToExpose`"

	if props?

		if Array.isArray props

			exposePropsFromArray props, cls, memberName

		else

			throw Error "Invalid value for `_propsToExpose`"

	return

exposeMethodsFromArray = (methods, child, cls, memberName) ->

	for method in methods then do ->

		func = child::[method]

		cls::[method] = ->

			member = @[memberName]

			func.apply member, arguments

			@

	return

exposeAllMethods = (child, cls, memberName) ->

	methods = []

	for methodName of child::

		continue if methodName[0] is '_'

		desc = Object.getOwnPropertyDescriptor child::, methodName

		continue if desc.get?

		methods.push methodName

	exposeMethodsFromArray methods, child, cls, memberName

exposePropsFromArray = (props, cls, memberName) ->

	for prop in props then do ->

		propName = prop

		getter cls::, propName, ->

			@[memberName][propName]

	return