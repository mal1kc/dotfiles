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

-- laptop
Util.MachineSpecificCfg(hl.layer_rule, {
	name = "fnott-blur",
	match = { namespace = "fnott" },
	blur = true,
	ignore_alpha = 0.3,
}, "laptop")

Util.MachineSpecificCfg(
	-- optional: snappier notification animation
	hl.layer_rule,
	{
		name = "fnott-anim",
		match = { namespace = "fnott" },
		animation = "slide right",
	},
	"laptop"
)
