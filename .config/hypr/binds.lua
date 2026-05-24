---------------------
---- KEYBINDINGS ----
---------------------

local mainMod = "SUPER" -- Sets "Windows" key as main modifier
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

-- Example binds, see https://wiki.hypr.land/Configuring/Basics/Binds/ for more
hl.bind(mainMod .. " + Q", hl.dsp.exec_cmd(term))
local closeWindowBind = hl.bind(mainMod .. " + C", hl.dsp.window.close())
-- closeWindowBind:set_enabled(false)

-- app bindings g1
hl.bind(mainMod .. " + SHIFT +  Return", hl.dsp.exec_cmd(term))
hl.bind(mainMod .. " + SHIFT +  Q", hl.dsp.exec_cmd("systemclt --user exit"))
hl.bind(mainMod .. " + L", hl.dsp.exec_cmd(interactive_powermenu))
hl.bind(mainMod .. " + SHIFT + E", hl.dsp.exec_cmd(term .. " yazi"))
hl.bind(mainMod .. " + E ", hl.dsp.exec_cmd(term .. "+ neovide"))
hl.bind(mainMod .. " + B ", hl.dsp.exec_cmd(term .. "+ librewolf"))

--main bindings
hl.bind(mainMod .. " + SHIFT +  C", hl.dsp.window.kill("activewindow"))
hl.bind(mainMod .. " + V ", hl.dsp.window.float({}))
hl.bind(mainMod .. " + V ", hl.dsp.window.center())
-- hl.bind(mainMod .. " + SHIFT" .. " +  Q", hl.dsp.exit())

hl.bind("F11", hl.dsp.window.fullscreen_state({ internal = 1, client = 1 }))

hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen_state({ internal = 0, client = 1 }))
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen())
hl.bind(mainMod .. " + SHIFT + F", hl.dsp.window.fullscreen_state({ internal = 0, client = 3 }))
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen(), { long_press = true })
hl.bind(mainMod .. " + SHIFT + F", hl.dsp.window.fullscreen_state({ internal = 0, client = 3 })) -- that shit is powerfull

hl.bind(mainMod .. " + scedilla", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + scedilla", hl.dsp.window.pin())

-- group binds
hl.bind(mainMod .. " + T", hl.dsp.group.move_window({ forward = true }))
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
hl.bind(mainMod .. " + Return", hl.dsp.layout("cyclenext"))
hl.bind(mainMod .. " + Return", hl.dsp.window.cycle_next(""))

hl.bind(mainMod .. " + SHIFT + left", hl.dsp.window.move({ direction = "l" }))
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.move({ direction = "r" }))
hl.bind(mainMod .. " + SHIFT + up", hl.dsp.window.move({ direction = "u" }))
hl.bind(mainMod .. " + SHIFT + down", hl.dsp.window.move({ direction = "d" }))

hl.bind(mainMod .. " + ALT + left", hl.dsp.window.move({ monitor = "-1" }))
hl.bind(mainMod .. " + ALT + right", hl.dsp.window.move({ monitor = "+1" }))

hl.bind(mainMod .. " + SHIFT + n", hl.dsp.window.cycle_next(""))

-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
for i = 1, 7 do
	local key = i % 10 -- 10 maps to key 0
	hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
	hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Example special workspace (scratchpad)
hl.bind(mainMod .. " + C", hl.dsp.workspace.toggle_special(""))
hl.bind(mainMod .. " + X", hl.dsp.window.move({ workspace = "special" }))

hl.bind(mainMod .. " + SHIFT + mouse_up", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + SHIFT + mouse_down", hl.dsp.focus({ workspace = "e-1" }))

hl.bind(mainMod .. " + mouse_up", hl.dsp.layout("move +col"))
hl.bind(mainMod .. " + mouse_down", hl.dsp.layout("move -col"))

hl.bind(mainMod .. " + page_up", hl.dsp.layout("move +col"))
hl.bind(mainMod .. " + page_down", hl.dsp.layout("move -col"))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Laptop multimedia keys for volume and LCD brightness
hl.bind(
	"XF86AudioRaiseVolume",
	hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioLowerVolume",
	hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
	{ locked = true, repeating = true }
)
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
