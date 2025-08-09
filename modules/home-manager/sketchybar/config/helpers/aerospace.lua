local function parse_window(str)
	local parts = {}
	for part in string.gmatch(str, "[^|]+") do
		table.insert(parts, part:match("^%s*(.-)%s*$"))
	end
	return parts
end

local function parse_windows(str)
	local apps = {}
	for line in string.gmatch(str, "[^\n]+") do
		table.insert(apps, parse_window(line))
	end
	return apps
end

return {
	parse_window = parse_window,
	parse_windows = parse_windows,
}
