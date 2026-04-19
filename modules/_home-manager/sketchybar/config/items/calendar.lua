local settings = require("settings")
local colors = require("colors")

local cal = sbar.add("item", {
	icon = {
		color = colors.foreground,
		padding_left = 5,
		font = {
			style = settings.font.style_map["Bold"],
			size = 13.0,
		},
	},
	label = {
		color = colors.foreground,
		padding_right = 5,
		align = "right",
		font = { family = settings.font.mono },
	},
	position = "right",
	update_freq = 30,
	padding_left = 1,
	padding_right = 1,
})

cal:subscribe({ "forced", "routine", "system_woke" }, function(env)
	cal:set({ icon = os.date("%a. %d %b."), label = os.date("%H:%M") })
end)
