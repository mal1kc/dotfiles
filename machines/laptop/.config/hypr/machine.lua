-- Settings of this machine, loaded last so they win over the core files.
-- Programs to start: ~/.local/bin/machine_autostart, idle: hypridle.conf

-- monitors, see https://wiki.hypr.land/Configuring/Basics/Monitors/
local monitor1 = "eDP-1"
-- local monitor2 = "HDMI-A-1"

hl.monitor({
	output = monitor1,
	mode = "1920x1080",
	position = "0x0",
	scale = 1,
})

hl.workspace_rule({
	workspace = "1",
	monitor = monitor1,
})

-- TODO: make toggle while using nvidia card \
--        & manual or automatic
-- Nvidia specific settings
-- hl.env("LIBVA_DRIVER_NAME", "nvidia")
-- hl.env("GBM_BACKEND", "nvidia-drm")
-- hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
-- -- for va-api hardware accel
hl.env("NVD_BACKEND", "direct")

hl.device({
	name = "steelseries-steelseries-rival-3",
	sensitivity = -0.9,
})

hl.config({
	input = {
		scroll_factor = 2.0,
	},
	decoration = {
		shadow = {
			enabled = false,
		},
	},
	misc = {
		animate_mouse_windowdragging = false,
		focus_on_activate = false,
	},
	scrolling = {
		focus_fit_method = 1,
		column_width = 0.6,
		follow_min_visible = 0.15,
	},
})

hl.layer_rule({
	name = "fnott-blur",
	match = { namespace = "fnott" },
	blur = true,
	ignore_alpha = 0.3,
})

-- optional: snappier notification animation
hl.layer_rule({
	name = "fnott-anim",
	match = { namespace = "fnott" },
	animation = "slide right",
})
