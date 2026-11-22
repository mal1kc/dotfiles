---------------------
---- KEYBINDINGS ----
---------------------

local mainMod = MainMod -- set in hyprland.lua
local home_dir = os.getenv("HOME")
local up_vol = "wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+"
local down_vol = "wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%-"
local toggle_vol = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"

local media_next = "playerctl next"
local media_prev = "playerctl previous"
local media_playpause = "playerctl play-pause"

-- local term = "kitty"
local term = "foot"

local interactive_powermenu = home_dir .. "/.local/bin/select_tool_json.py powermenu"

local screenshot_cmd = home_dir .. "/.local/bin/screenshot --notify"
local screenshot_cmd_full = home_dir .. "/.local/bin/screenshot_fullscreen --notify"

local palette = home_dir .. "/.local/bin/select_tool_json.py hyprland"

-- one bind, several dispatchers (two binds on a key are easy to overlook)
local function run_all(...)
	local dispatchers = { ... }
	return function()
		for _, dispatcher in ipairs(dispatchers) do
			hl.dispatch(dispatcher)
		end
	end
end

-- send a layout message chosen by the layout of the active workspace,
-- layouts that aren't listed get nothing
local function layout_msg(messages)
	return function()
		local workspace = Util.layout_workspace()
		local msg = workspace and messages[workspace.tiled_layout]
		if msg then
			hl.dispatch(hl.dsp.layout(msg))
		end
	end
end

-- Example binds, see https://wiki.hypr.land/Configuring/Basics/Binds/ for more
-- hl.bind(mainMod .. " + Q", hl.dsp.exec_cmd(term))
-- local closeWindowBind = hl.bind(mainMod .. " + C", hl.dsp.window.close())
-- closeWindowBind:set_enabled(false)

-- app bindings g1
hl.bind(mainMod .. " + SHIFT +  Return", hl.dsp.exec_cmd(term))
hl.bind(mainMod .. " + L", hl.dsp.exec_cmd(interactive_powermenu))
hl.bind(mainMod .. " + P", hl.dsp.exec_cmd(palette))
hl.bind(mainMod .. " + N", hl.dsp.exec_cmd(home_dir .. "/.local/bin/notifs list"))
-- show this file (read only)
hl.bind(mainMod .. " + K", hl.dsp.exec_cmd("foot -a show_binds nvim -R " .. home_dir .. "/.config/hypr/binds.lua"))
hl.bind(mainMod .. " + SHIFT + E", hl.dsp.exec_cmd(term .. " yazi"))
hl.bind(mainMod .. " + E ", hl.dsp.exec_cmd("neovide"))
hl.bind(mainMod .. " + B ", hl.dsp.exec_cmd("librewolf"))

--main bindings
hl.bind(mainMod .. " + SHIFT +  Q", hl.dsp.exit())

hl.bind(mainMod .. " + SHIFT +  C", hl.dsp.window.close("activewindow"))
hl.bind(mainMod .. " + V ", run_all(hl.dsp.window.float({}), hl.dsp.window.center()))
-- hl.bind(mainMod .. " + SHIFT" .. " +  Q", hl.dsp.exit())

-- fullscreen: internal = what hyprland does, client = what the app is told
-- (0 none, 1 maximized, 2 fullscreen)
local function fullscreen(internal, client)
	return hl.dsp.window.fullscreen_state({ internal = internal, client = client, action = "toggle" })
end

-- maximize
hl.bind(mainMod .. " + F", fullscreen(1, 0))
-- fake: app thinks it's fullscreen, window keeps its size and float state
hl.bind(mainMod .. " + CTRL + F", fullscreen(0, 2))
-- real
hl.bind(mainMod .. " + SHIFT + F", fullscreen(2, 2))
hl.bind("F11", fullscreen(2, 2))

hl.bind(mainMod .. " + scedilla", run_all(hl.dsp.window.float({ action = "toggle" }), hl.dsp.window.pin()))

-- group binds
hl.bind(mainMod .. " + T", hl.dsp.group.next({ forward = true }))
hl.bind(mainMod .. " + Y", hl.dsp.window.move({ out_of_group = true }))
hl.bind(mainMod .. " + SHIFT + T", hl.dsp.group.toggle())

-- app bindings2
hl.bind("CONTROL + SHIFT + ESCAPE", hl.dsp.exec_cmd(term .. " -T btop btop"))
hl.bind("ALT + SPACE", hl.dsp.exec_cmd("fuzzel"))

hl.bind("Print", hl.dsp.exec_cmd(screenshot_cmd))
hl.bind(mainMod .. " + S", hl.dsp.exec_cmd(screenshot_cmd))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd(screenshot_cmd_full))

-- Move focus with mainMod + arrow keys
hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "down" }))
hl.bind(mainMod .. " + Return", hl.dsp.window.cycle_next(""))

-- the focused window if it is tiled by masterscroll
local function masterscroll_window()
	local window = hl.get_active_window()
	local workspace = Util.layout_workspace()
	if
		window
		and not window.floating
		and workspace
		and workspace.tiled_layout == "lua:masterscroll"
		and window.workspace
		and window.workspace.name == workspace.name
	then
		return window
	end
end

-- Move the window. Towards the master: become master (master and masterscroll).
-- Lua layouts only know previous/next, so masterscroll gets a layout message.
local function move_window(direction)
	local move = hl.dsp.window.move({ direction = direction, group_aware = true })
	return function()
		local window = masterscroll_window()
		if window and not window.group then
			hl.dispatch(hl.dsp.layout("move " .. direction))
		else
			hl.dispatch(move)
		end
	end
end

hl.bind(mainMod .. " + SHIFT + left", move_window("l"))
hl.bind(mainMod .. " + SHIFT + right", move_window("r"))
hl.bind(mainMod .. " + SHIFT + up", move_window("u"))
hl.bind(mainMod .. " + SHIFT + down", move_window("d"))

-- master area on the left / right side
hl.bind(
	mainMod .. " + CTRL + left",
	layout_msg({ master = "orientationleft", ["lua:masterscroll"] = "orientationleft" })
)
hl.bind(
	mainMod .. " + CTRL + right",
	layout_msg({ master = "orientationright", ["lua:masterscroll"] = "orientationright" })
)

hl.bind(mainMod .. " + " .. AltMod .. " + left", hl.dsp.window.move({ monitor = "-1" }))
hl.bind(mainMod .. " + " .. AltMod .. " + right", hl.dsp.window.move({ monitor = "+1" }))

hl.bind(mainMod .. " + SHIFT + n", hl.dsp.window.cycle_next(""))

-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
for i = 1, 7 do
	local key = i % 10 -- 10 maps to key 0
	hl.bind(mainMod .. " + " .. key, function()
		hl.dispatch(hl.dsp.focus({ workspace = i }))
		-- an open overview may show another workspace than the real one
		local gloview = hl.plugin.gloview
		if gloview then
			gloview.setworkspace(i)
		end
	end)
	hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Example special workspace (scratchpad)
hl.bind(mainMod .. " + C", hl.dsp.workspace.toggle_special(""))
hl.bind(mainMod .. " + X", hl.dsp.window.move({ workspace = "special" }))

hl.bind(mainMod .. " + SHIFT + mouse_up", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + SHIFT + mouse_down", hl.dsp.focus({ workspace = "e-1" }))

-- next / previous column or window
local next_col = layout_msg({
	scrolling = "move +col",
	["lua:masterscroll"] = "move +col",
	master = "cyclenext",
	monocle = "cyclenext",
})
local prev_col = layout_msg({
	scrolling = "move -col",
	["lua:masterscroll"] = "move -col",
	master = "cycleprev",
	monocle = "cycleprev",
})
hl.bind(mainMod .. " + mouse_up", next_col)
hl.bind(mainMod .. " + mouse_down", prev_col)

hl.bind(mainMod .. " + page_up", next_col)
hl.bind(mainMod .. " + page_down", prev_col)

-- ö, ç

hl.bind(
	mainMod .. " +  odiaeresis",
	layout_msg({ scrolling = "swapcol l", ["lua:masterscroll"] = "swapcol l", master = "swapprev" })
)
hl.bind(
	mainMod .. " +  ccedilla",
	layout_msg({ scrolling = "swapcol r", ["lua:masterscroll"] = "swapcol r", master = "swapnext" })
)
-- scrolling: own column, master and masterscroll: become master
hl.bind(
	mainMod .. " +  period",
	layout_msg({ scrolling = "promote", ["lua:masterscroll"] = "promote", master = "swapwithmaster" })
)

-- narrower / wider (the two keys right of 0 on TR-Q are asterisk and minus)
hl.bind(
	mainMod .. " + minus",
	layout_msg({ scrolling = "colresize -conf", ["lua:masterscroll"] = "colresize -conf", master = "mfact -0.05" })
)
hl.bind(
	mainMod .. " + asterisk",
	layout_msg({ scrolling = "colresize +conf", ["lua:masterscroll"] = "colresize +conf", master = "mfact +0.05" })
)
-- master sized column
hl.bind(
	mainMod .. " + M",
	layout_msg({ scrolling = "colresize 0.6", ["lua:masterscroll"] = "colresize 0.6", master = "mfact exact 0.6" })
)
-- visible columns share the screen
hl.bind(mainMod .. " + G", layout_msg({ scrolling = "fit visible" }))
-- stack into the previous column / take out again
hl.bind(mainMod .. " + comma", layout_msg({ scrolling = "consume_or_expel prev" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
-- Called at press and again at release. Lua layouts aren't told how far the mouse
-- went, masterscroll reads it from Util.mouse_resize.
hl.bind(mainMod .. " + mouse:273", function()
	local pos = hl.get_cursor_pos()
	local workspace = Util.layout_workspace()
	if Util.mouse_resize then
		Util.mouse_resize = nil
	else
		-- workspace stays nil on floating windows: nothing in the layout moves
		local tiled = pos and workspace and not Util.floating_at(pos)
		Util.mouse_resize = { x = pos and pos.x, y = pos and pos.y, workspace = tiled and workspace.name }
	end
	-- its result asks Hyprland for the release call
	return hl.dispatch(hl.dsp.window.resize())
end, { mouse = true })

-- will switch to a submap called resize
hl.bind(mainMod .. " + R", hl.dsp.submap("resize"))

local function resize(x, y)
	local dispatcher = hl.dsp.window.resize({ x = x, y = y, relative = true })
	return function()
		if masterscroll_window() then
			hl.dispatch(hl.dsp.layout("resize " .. x .. " " .. y))
		else
			hl.dispatch(dispatcher)
		end
	end
end

-- Start a submap called "resize".
hl.define_submap("resize", function()
	-- Set repeating binds for resizing the active window.
	hl.bind("right", resize(10, 0), { repeating = true })
	hl.bind("left", resize(-10, 0), { repeating = true })
	hl.bind("up", resize(0, 10), { repeating = true })
	hl.bind("down", resize(0, -10), { repeating = true })

	-- Use `reset` to go back to the global submap
	hl.bind("escape", hl.dsp.submap("reset"))
end)

-- Laptop multimedia keys for volume and LCD brightness
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd(up_vol), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd(down_vol), { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd(toggle_vol), { locked = true, repeating = true })
hl.bind(
	"XF86AudioMicMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
	{ locked = true, repeating = true }
)

-- hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
-- hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("xbacklight -inc 5"), { locked = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("xbacklight -dec 5"), { locked = true })

-- Requires playerctl
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd(media_playpause), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd(media_playpause), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd(media_prev), { locked = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd(media_next), { locked = true })
hl.bind(mainMod .. " + XF86AudioMute", hl.dsp.exec_cmd(media_prev), { locked = true })
hl.bind(mainMod .. " + XF86AudioLowerVolume", hl.dsp.exec_cmd(media_playpause), { locked = true })
hl.bind(mainMod .. " + XF86AudioRaiseVolume", hl.dsp.exec_cmd(media_next), { locked = true })
