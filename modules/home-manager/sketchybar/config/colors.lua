return {
	background = 0xff161616,
	foreground = 0xfff2f4f8,
	accent_background = 0xff2a2a2a,

	gray = 0xff282828,
	red = 0xffee5396,
	green = 0xff25be6a,
	teal = 0xff08bdba,
	purple = 0xff78a9ff,
	violet = 0xffbe95ff,
	blue = 0xff33b1ff,
	light_gray = 0xffdfdfe0,
	cyan = 0xff3ddbd9,
	pink = 0xffff7eb6,

	transparent = 0,

	with_alpha = function(color, alpha)
		if alpha > 1.0 or alpha < 0.0 then
			return color
		end
		return (color & 0x00ffffff) | (math.floor(alpha * 255.0) << 24)
	end,
}

-- TODO: correct colorscheme
-- # Nightfox colors for Kitty
-- ## name: carbonfox
-- ## upstream: https://github.com/edeneast/nightfox.nvim/raw/main/extra/carbonfox/kitty.conf
--
-- background #161616
-- foreground #f2f4f8
-- selection_background #2a2a2a
-- selection_foreground #f2f4f8
-- cursor_text_color #161616
-- url_color #25be6a
--
-- # Cursor
-- # uncomment for reverse background
-- # cursor none
-- cursor #f2f4f8
--
-- # Border
-- active_border_color #78a9ff
-- inactive_border_color #535353
-- bell_border_color #3ddbd9
--
-- # Tabs
-- active_tab_background #78a9ff
-- active_tab_foreground #0c0c0c
-- inactive_tab_background #2a2a2a
-- inactive_tab_foreground #6e6f70
--
-- # normal
-- color0 #282828
-- color1 #ee5396
-- color2 #25be6a
-- color3 #08bdba
-- color4 #78a9ff
-- color5 #be95ff
-- color6 #33b1ff
-- color7 #dfdfe0
--
-- # bright
-- color8 #484848
-- color9 #f16da6
-- color10 #46c880
-- color11 #2dc7c4
-- color12 #8cb6ff
-- color13 #c8a5ff
-- color14 #52bdff
-- color15 #e4e4e5
--
-- # extended colors
-- color16 #3ddbd9
-- color17 #ff7eb6
