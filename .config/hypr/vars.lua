hl.workspace_rule({
	workspace = "5",
	layout = "monocle",
})

Util.MachineSpecificCfg(hl.workspace_rule, {
	workspace = "6",
	layout = "master",
}, "laptop")

hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })
hl.curve("md_3_decel", { type = "bezier", points = { { 0.05, 0.7 }, { 0.1, 1 } } })
hl.curve("md_3_accel", { type = "bezier", points = { { 0.3, 0 }, { 0.8, 0.15 } } })
hl.curve("popin", { type = "bezier", points = { { 0.1, 1.5 }, { 0.76, 0.92 } } })
hl.curve("menu_decel", { type = "bezier", points = { { 0.1, 1 }, { 0, 1 } } })
hl.curve("menu_accel", { type = "bezier", points = { { 0.38, 0.04 }, { 1, 0.07 } } })

hl.device({
	name = "steelseries-steelseries-rival-3",
	sensitivity = -0.9,
})

-- desktop
Util.MachineSpecificCfg(hl.env, { "XDG_CURRENT_DESKTOP", "Hyprland" }, "desktop")
Util.MachineSpecificCfg(hl.env, { "XDG_SESSION_TYPE", "wayland" }, "desktop")
Util.MachineSpecificCfg(hl.env, { "XDG_SESSION_DESKTOP", "Hyprland" }, "desktop")
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")

-- TODO: make toggle while using nvidia card \
--        & manual or outomatic
-- Nvidia specific settings
-- Util.MachineSpecificCfg(hl.env, { "LIBVA_DRIVER_NAME", "nvidia" }, "laptop")
-- Util.MachineSpecificCfg(hl.env, { "GBM_BACKEND", "nvidia-drm" }, "laptop")
-- Util.MachineSpecificCfg(hl.env, { "__GLX_VENDOR_LIBRARY_NAME", "nvidia" }, "laptop")
-- -- for va-api hardware accel
Util.MachineSpecificCfg(hl.env, { "NVD_BACKEND", "direct" }, "laptop")

Util.MachineSpecificCfg(hl.config, {
	input = {
		scroll_factor = 1,
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
		column_width = 0.7,
		follow_min_visible = 0.1,
	},
}, "desktop")

Util.MachineSpecificCfg(hl.config, {
	input = {
		scroll_factor = 2.0,
	},
	decoration = {
		shadow = {
			enabled = false,
		},
	},
	general = {
		gaps_out = 7,
	},
	misc = {
		animate_mouse_windowdragging = false,
	},
	scrolling = {
		focus_fit_method = 1,
		column_width = 0.85,
		follow_min_visible = 0.15,
	},
}, "laptop")

hl.config({
	debug = {
		disable_logs = false,
		vfr = true,
	},
	-- For all categories, see https://wiki.hypr.land/Configuring/Basics/Variables/
	input = {
		kb_layout = "tr",
		kb_variant = "",
		kb_model = "",
		kb_options = "",
		kb_rules = "",
		follow_mouse = 1,
		touchpad = {
			natural_scroll = true,
		},
		-- sensitivity = 0 # -1.0 - 1.0, 0 means no modification.
	},
	general = {
		gaps_in = 3,
		border_size = 2,
		col = {
			active_border = { colors = { "rgba(33ccffee)", "rgba(00ff99ee)" }, angle = 45 },
			inactive_border = "rgba(595959aa)",
		},
		-- layout = dwindle
		layout = "scrolling",
	},
	scrolling = {
		direction = "down",
	},
	decoration = {
		rounding = 2,
		blur = {
			enabled = true,
			size = 4,
			passes = 1,
			new_optimizations = true,
			xray = true,
		},
		shadow = {
			range = 4,
			render_power = 3,
			color = "rgba(1a1a1aee)",
		},
	},
	animations = {
		enabled = true,
	},
	dwindle = {
		preserve_split = true, -- you probably want this
	},
	master = {
		-- new_status = master
		center_master_fallback = "right",
	},
	misc = {
		enable_swallow = true,
		swallow_regex = "^(St)$",
		swallow_exception_regex = "^(wev)$",
		on_focus_under_fullscreen = 2, -- unfullscreen/unmaximize
		focus_on_activate = true,
		animate_manual_resizes = true,
	},
	cursor = {
		-- no_hardware_cursors = 1
		inactive_timeout = 20,
		hide_on_key_press = true,
		hide_on_touch = true,
		warp_on_change_workspace = true,
		warp_on_toggle_special = true,
	},
})
