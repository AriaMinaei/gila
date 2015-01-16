module.exports = string =

	allUpperCaseToCamelCase: (s) ->

		s
		.split('_')
		.map((word) ->

			word[0] + word.substr(1, word.length).toLowerCase()

		)
		.join ''