local colors = require("colors")

-- Equivalent to the --bar domain
sbar.bar({
	height = 26, -- misalligned if not even i guess
	position = "top",
	y_offset = 5,
	color = colors.with_alpha(colors.background, 0.9),
	padding_right = 2,
	padding_left = 2,
	margin = 12,
	corner_radius = 5,
})
