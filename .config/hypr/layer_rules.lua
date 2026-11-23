-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/

-- fuzzel: no animation (every submenu is a new window), blur behind it
hl.layer_rule({
	name = "fuzzel",
	match = { namespace = "^(launcher)$" },
	no_anim = true,
	blur = true,
	ignore_alpha = 0.3,
})
