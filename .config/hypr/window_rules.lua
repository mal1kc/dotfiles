-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/
-- Desktop
Util.MachineSpecificCfg(hl.layer_rule, {
	name = "swaync_layer_center",
	match = {
		namespace = "swaync-control-center",
	},
	blur = true,
	ignore_alpha = 0.3,
}, "desktop")

Util.MachineSpecificCfg(hl.layer_rule, {
	name = "swaync_layer_window",
	match = {
		namespace = "swaync-notification-window",
	},
	blur = true,
	ignore_alpha = 0.3,
}, "desktop")

-- laptop-desktop
hl.window_rule({
	name = "rofi_wrl",
	match = {
		class = "^(Rofi)$",
		title = "^(rofi - drun)$",
	},
	float = true,
})

hl.window_rule({
	name = "btop_wrl",
	match = {
		class = "^(foot)$",
		title = "^(btop)|(btop).[~/Z-a]$",
	},
	float = true,
})

hl.window_rule({
	name = "countdown_wrl",
	match = {
		class = "^(foot)$",
		title = "^(countdown)|(termdown)$",
	},
	float = true,
})

hl.window_rule({
	name = "godot_wrl",
	match = {
		class = "^(org.godotengine.Editor)|(org.godotengine.ProjectManager)$",
	},
	float = true,
	content = "game",
})

hl.window_rule({
	name = "kde_connect_wrl",
	match = {
		class = "^(org.kde.kdeconnect.daemon)$",
	},
	float = true,
})

hl.window_rule({
	name = "steam_game_wrl",
	match = {
		class = "^steam_app_.[0-9]*$",
	},
	content = "game",
})

hl.window_rule({
	name = "steam_wrl",
	match = {
		title = "^()$",
		class = "^(steam)$",
	},
	no_focus = true,
	min_size = { 10, 10 },
})

hl.window_rule({ match = { content = "game", fullscreen = true }, confine_pointer = true })
