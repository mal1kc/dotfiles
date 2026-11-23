-- Settings of this machine, loaded last so they win over the core files.
-- Programs to start: ~/.local/bin/machine_autostart, idle: hypridle.conf
--
-- What depends on the hardware is not set in base (hyprland uses its defaults),
-- uncomment what this machine needs.

-- names and modes: hyprctl monitors all
-- hl.monitor({
-- 	output = "DP-1",
-- 	mode = "1920x1080@60",
-- 	position = "0x0",
-- 	scale = 1,
-- })

-- hl.workspace_rule({ workspace = "1", monitor = "DP-1" })

-- names: hyprctl devices
-- hl.device({
-- 	name = "mouse-name",
-- 	sensitivity = 0,
-- })

-- graphics card
-- hl.env("LIBVA_DRIVER_NAME", "nvidia")
-- hl.env("GBM_BACKEND", "nvidia-drm")
-- hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
-- hl.env("NVD_BACKEND", "direct")

-- hl.config({
-- 	input = {
-- 		scroll_factor = 1,
-- 	},
-- 	decoration = {
-- 		shadow = {
-- 			enabled = true,
-- 		},
-- 	},
-- 	general = {
-- 		gaps_out = 7,
-- 	},
-- 	scrolling = {
-- 		column_width = 0.5,
-- 	},
-- })

hl.layer_rule({
	name = "fnott-blur",
	match = { namespace = "fnott" },
	blur = true,
	ignore_alpha = 0.3,
})

-- screen shader at night: latitude, longitude
-- require("bluelight")(0, 0)
