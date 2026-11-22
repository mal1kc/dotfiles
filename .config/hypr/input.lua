hl.device({
	name = "steelseries-steelseries-rival-3",
	sensitivity = -0.9,
})

Util.MachineSpecificCfg(hl.config, {
	input = {
		scroll_factor = 1,
	},
}, "desktop")

Util.MachineSpecificCfg(hl.config, {
	input = {
		scroll_factor = 2.0,
	},
}, "laptop")

hl.config({
	-- For all categories, see https://wiki.hypr.land/Configuring/Basics/Variables/
	input = {
		kb_layout = "tr",
		kb_variant = "",
		kb_model = "",
		kb_options = "",
		kb_rules = "",
		-- hover focus, hover.lua delays it (both are needed for that)
		follow_mouse = 1,
		mouse_refocus = true,
		touchpad = {
			natural_scroll = true,
		},
		-- sensitivity = 0 # -1.0 - 1.0, 0 means no modification.
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
