module.exports = flagsToIndex = (possibleFlags, flags) ->

	index = 0

	cur = 1

	for flag in possibleFlags

		if flags[flag] is yes

			index += cur

		cur *= 10

	index