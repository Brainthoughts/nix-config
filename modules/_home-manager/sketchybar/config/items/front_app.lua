local colors = require("colors")
local inspect = require("inspect")
local aerospace = require("helpers.aerospace")

local front_app = sbar.add("item", "front_app", {
	display = "active",
	icon = { color = colors.violet },
	label = { color = colors.light_gray, font = { size = 13 }, padding_left = 10 },
	updates = true,
	update_freq = 5,
})

-- need routine to update when titlebar changes without a focus change
-- unholy combination of aerospace and sketcybar trigger because front_app_switched
-- does not update if new window is same app and aerospace does not recognize finder as
-- focused app when clicking background
-- this double triggers when switching, there is probably a better solution
front_app:subscribe({ "aerospace_focus_changed", "front_app_switched", "routine" }, function(env)
	sbar.exec(aerospace.cmd .. " list-windows --focused ", function(result, code)
		if code == 0 then
			local apps = aerospace.parse_windows(result)
			front_app:set({ icon = { string = apps[1][2] }, label = { drawing = true, string = apps[1][3] } })
		else
			front_app:set({ icon = { string = env.INFO }, label = { drawing = false } })
		end
	end)
end)
