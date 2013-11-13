module.exports = class Texture

	constructor: (@gila, @url) ->

		@gl = @gila.gl

		@options =

			flipY: yes

		@texture = @gl.createTexture()

		@setImageFromUrl @url

	setImageFromUrl: (url) ->

		@ready = no

		@el = new Image

		@el.addEventListener 'load', =>

			@ready = yes

			do @_loadFromImage

		@el.src = url

		@

	_loadFromImage: ->

		@gl.bindTexture @gl.TEXTURE_2D, @texture

		@gl.pixelStorei @gl.UNPACK_FLIP_Y_WEBGL, @options.flipY

		# upload our image to the graphic card's texture space
		# params:
		# what kind of texture we're using
		@gl.texImage2D @gl.TEXTURE_2D,

			# the mipmap level
			0,

			# how it should be stored on the card
			@gl.RGBA, @gl.RGBA,

			# the size of each "channel" of the image (the data type used to store
			# red, green, or blue)
			@gl.UNSIGNED_BYTE,

			# the image itself
			@el

		# @gl.generateMipmap @gl.TEXTURE_2D

		@gl.texParameteri @gl.TEXTURE_2D, @gl.TEXTURE_MAG_FILTER, @gl.LINEAR

		@gl.texParameteri @gl.TEXTURE_2D, @gl.TEXTURE_MIN_FILTER, @gl.LINEAR

		@gl.bindTexture @gl.TEXTURE_2D, null

	assignToSlot: (n) ->

		if @gila.debug and not @ready

			console.warn "Texture '#{@url}' is not loaded yet"

		n = parseInt n

		if @gila.debug and not (0 <= n <= 31)

			throw Error "n out of range: `#{n}`"

		slot = @gl['TEXTURE' + n]

		# we have TEXTURE0 to TEXTURE31 (32 slots)
		#
		# now we're saying that TEXTURE0 is...
		@gl.activeTexture slot

		# ... the one we loaded just before
		@gl.bindTexture @gl.TEXTURE_2D, @texture

		@