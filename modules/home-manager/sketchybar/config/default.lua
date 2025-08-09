local settings = require("settings")
local colors = require("colors")

-- Equivalent to the --default domain
sbar.default({
	updates = "when_shown",
	icon = {
		font = {
			family = settings.font.text,
			style = settings.font.style_map["Bold"],
			size = 15.0,
		},
		color = colors.foreground,
		padding_left = settings.paddings,
		padding_right = settings.paddings,
		-- background = { image = { corner_radius = 9 } },
	},
	label = {
		font = {
			family = settings.font.mono,
			style = settings.font.style_map["Semibold"],
			size = 14.0,
		},
		color = colors.foreground,
		padding_left = settings.paddings,
		padding_right = settings.paddings,
	},
	background = {
		height = 22,
		corner_radius = 5,
		border_color = colors.gray,
		border_width = 1,
	},
	popup = {
		background = {
			border_width = 2,
			corner_radius = 9,
			border_color = colors.gray,
			color = colors.accent_background,
			shadow = { drawing = true },
		},
		blur_radius = 50,
	},
	padding_left = 5,
	padding_right = 5,
	scroll_texts = true,
})
