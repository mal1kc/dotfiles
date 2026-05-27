-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/
-- Desktop
Util.MachineSpecificConfig(hl.layer_rule, {
	name = "swaync_layer_center",
	match = {
		namespace = "swaync-control-center",
	},
	blur = true,
	ignore_alpha = 0.3,
}, "desktop")

Util.MachineSpecificConfig(hl.layer_rule, {
	name = "swaync_layer_window",
	match = {
		namespace = "swaync-notification-window",
	},
	blur = true,
	ignore_alpha = 0.3,
}, "desktop")

-- laptop-desktop
hl.window_rule({
	name = "rofi_window_rl",
	match = {
		class = "^(Rofi)$",
		title = "^(rofi - drun)$",
	},
	float = true,
})

hl.window_rule({
	name = "btop_window_rl",
	match = {
		class = "^(foot)$",
		title = "^(btop)|(btop).[~/Z-a]$",
	},
	float = true,
})

hl.window_rule({
	name = "countdown_window_rl",
	match = {
		class = "^(foot)$",
		title = "^(countdown)|(termdown)$",
	},
	float = true,
})

hl.window_rule({
	name = "godot_window_rl",
	match = {
		class = "^(org.godotengine.Editor)|(org.godotengine.ProjectManager)$",
	},
	float = true,
	content = "game",
})

hl.window_rule({
	name = "steam_window_rl",
	match = {
		title = "^()$",
		class = "^(steam)$",
	},
	no_focus = true,
	min_size = { 10, 10 },
})
