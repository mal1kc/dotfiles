-- Settings of this machine, loaded last so they win over the core files.
-- Programs to start: ~/.local/bin/machine_autostart, idle: hypridle.conf

-- monitors, see https://wiki.hypr.land/Configuring/Basics/Monitors/
local monitor1 = "DP-1"
local monitor2 = "DP-2"

hl.monitor({
	output = monitor1,
	mode = "2560x1440@180",
	position = "0x0",
	scale = 1,
})

hl.monitor({
	output = monitor2,
	mode = "1600x900@60",
	position = "2560x300",
	scale = 1,
})

hl.workspace_rule({
	workspace = "1",
	monitor = monitor1,
})

hl.workspace_rule({
	workspace = "2",
	monitor = monitor2,
})

hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")

hl.device({
	name = "steelseries-steelseries-rival-3",
	sensitivity = -0.9,
})

hl.config({
	input = {
		scroll_factor = 1,
	},
	misc = {
		focus_on_activate = true,
	},
	decoration = {
		shadow = {
			enabled = true,
		},
	},
	general = {
		gaps_out = 8,
	},
	scrolling = {
		column_width = 0.5,
		follow_min_visible = 0.1,
	},
})

hl.layer_rule({
	name = "swaync_layer_center",
	match = {
		namespace = "swaync-control-center",
	},
	blur = true,
	ignore_alpha = 0.3,
})

hl.layer_rule({
	name = "swaync_layer_window",
	match = {
		namespace = "swaync-notification-window",
	},
	blur = true,
	ignore_alpha = 0.3,
})

-- screen shader at night: latitude, longitude (also in machine_autostart)
require("bluelight")(40.92, 29.92)
