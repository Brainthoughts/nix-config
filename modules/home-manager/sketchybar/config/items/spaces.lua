local colors = require("colors")
local settings = require("settings")
local inspect = require("inspect")
local aerospace = require("helpers.aerospace")

local MAX_POPUP_ITEMS = 10

-- popen fine here since only initial setup
local initial_focused_workspace = io.popen(aerospace.cmd .. " list-workspaces --focused"):read()
for i in io.popen(aerospace.cmd .. " list-workspaces --all"):lines() do
	local space = sbar.add("item", "space." .. i, {
		drawing = true,
		icon = {
			string = i,
			font = { family = settings.font.mono },
			padding_left = 10,
			padding_right = 10,
			color = colors.foreground,
			highlight_color = colors.violet,
			highlight = initial_focused_workspace == i,
		},
		label = {
			drawing = false,
		},
		background = {
			color = colors.accent_background,
		},
		padding_right = 0,
		padding_left = 0,
		popup = { background = { border_width = 0 } },
	})

	-- Padding space
	sbar.add("item", "space.padding." .. i, {
		width = settings.group_paddings / 2,
	})

	local popup_slots = {}
	for j = 1, MAX_POPUP_ITEMS, 1 do
		popup_slots[j] = sbar.add("item", {
			position = "popup." .. space.name,
			icon = {},
			label = {
				padding_left = 10,
				font = {
					family = settings.font.mono,
				},
				color = colors.light_gray,
			},
		})
	end

	space:subscribe("aerospace_workspace_change", function(env)
		local selected = env.FOCUSED == i
		space:set({
			icon = { highlight = selected },
		})
	end)

	space:subscribe("mouse.clicked", function(env)
		if env.BUTTON == "left" then
			sbar.exec(aerospace.cmd .. " workspace " .. i)
		end
	end)

	-- TODO: make last focused space have color as well
	space:subscribe("mouse.entered", function(_)
		sbar.exec(aerospace.cmd .. " list-windows --workspace " .. i, function(result, code)
			local apps = aerospace.parse_windows(result)
			sbar.exec(aerospace.cmd .. " list-windows --focused ", function(result, code)
				local focused_app = aerospace.parse_windows(result)[1]
				for j, item in pairs(popup_slots) do
					local app = apps[j]
					if app then
						local icon_color = focused_app and app[1] == focused_app[1] and colors.violet
							or focused_app and app[2] == focused_app[2] and colors.blue
							or colors.foreground
						item:set({
							drawing = true,
							icon = { string = app[2], color = icon_color },
							label = { string = app[3] },
						})
						space:set({ popup = { drawing = true } })
					else
						item:set({ drawing = false })
					end
				end
			end)
		end)
	end)

	space:subscribe("mouse.exited", function(_)
		space:set({ popup = { drawing = false } })
	end)
end
