-- sh_menu.lua
-- uosc-compatible shader selector (uses uosc Menu API as in wiki example)
local mp = require("mp")
local msg = require("mp.msg")
local utils = require("mp.utils")

local script_name = mp.get_script_name()
local shaders_dir = mp.command_native({ "expand-path", "~/.config/mpv/shaders" })

local function command(str)
	return string.format("script-message-to %s %s", script_name, str)
end

local function list_shader_files()
	local files = utils.readdir(shaders_dir, "files")
	if not files then
		return {}
	end
	table.sort(files)
	local out = {}
	for _, f in ipairs(files) do
		if not f:match("^%.") then
			table.insert(out, f)
		end
	end
	return out
end

local function create_menu_data()
	local items = {}
	local shaders = list_shader_files()

	if #shaders == 0 then
		table.insert(items, { title = "No shaders found", disabled = true })
	else
		for _, fname in ipairs(shaders) do
			table.insert(items, {
				title = fname,
				hint = "",
				-- value should be a command that sends a script-message back to this script
				value = command(string.format('apply "%s" "%s"', shaders_dir .. "/" .. fname, fname)),
			})
		end
	end

	table.insert(items, { title = "—", disabled = true })
	table.insert(items, {
		title = "Clear shaders",
		icon = "delete",
		value = command("clear"),
	})

	return {
		type = "shaders_menu",
		title = "Shaders",
		keep_open = false,
		items = items,
	}
end

-- Open menu keybinding (Ctrl+5)
mp.add_forced_key_binding("Ctrl+5", "open-shaders-menu", function()
	local json = utils.format_json(create_menu_data())
	-- open-menu expects full JSON string as single arg
	mp.commandv("script-message-to", "uosc", "open-menu", json)
end)

-- Also provide an endpoint so uosc can request/update the menu if needed
mp.register_script_message("request_menu", function()
	local json = utils.format_json(create_menu_data())
	mp.commandv("script-message-to", "uosc", "update-menu", json)
end)

-- Handlers invoked by the menu's value commands
mp.register_script_message("apply", function(path, name)
	if not path or path == "" then
		return
	end
	mp.set_property_native("glsl-shaders", { path })
	mp.osd_message(name or path)
	msg.info("Applied shader: " .. path)
end)

mp.register_script_message("clear", function()
	mp.set_property_native("glsl-shaders", {})
	mp.osd_message("Shaders cleared")
	msg.info("Cleared shaders")
end)

msg.info("sh_menu loaded; shaders_dir=" .. shaders_dir)
