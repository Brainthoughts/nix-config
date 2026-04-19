local colors = require("colors")
local icons = require("icons")
local settings = require("settings")

local focus = sbar.add("item", "widgets.focus", {
	position = "right",
	icon = {
		string = icons.focus.none,
	},
	label = { drawing = false },
	update_freq = 60,
})

local function update_focus(env)
	sbar.exec('osascript -e \'tell application "Shortcuts" to run shortcut "Get-Focus"\'', function(output, code)
		if not code == 0 then
			focus:set({
				icon = {
					color = colors.red,
				},
			})
			return
		end
		if output == "\n" then
			focus:set({
				icon = {
					string = icons.focus.none,
					color = colors.foreground,
				},
			})
		elseif output == "Sleep\n" then
			focus:set({
				icon = {
					string = icons.focus.sleep,
					color = colors.violet,
				},
			})
		else
			focus:set({
				icon = {
					string = icons.focus.dnd,
					color = colors.violet,
				},
			})
		end
	end)
end

focus:subscribe({ "routine", "system_woke" }, update_focus)

sbar.add("bracket", "widgets.focus.bracket", { focus.name }, {
	background = { color = colors.accent_background },
})

sbar.add("item", "widgets.focus.padding", {
	position = "right",
	width = settings.group_paddings,
})
