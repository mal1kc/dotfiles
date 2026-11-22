hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })
hl.curve("md_3_decel", { type = "bezier", points = { { 0.05, 0.7 }, { 0.1, 1 } } })
hl.curve("md_3_accel", { type = "bezier", points = { { 0.3, 0 }, { 0.8, 0.15 } } })
hl.curve("popin", { type = "bezier", points = { { 0.1, 1.5 }, { 0.76, 0.92 } } })
hl.curve("menu_decel", { type = "bezier", points = { { 0.1, 1 }, { 0, 1 } } })
hl.curve("menu_accel", { type = "bezier", points = { { 0.38, 0.04 }, { 1, 0.07 } } })

hl.animation({
	leaf = "windows",
	enabled = true,
	speed = 3,
	bezier = "md_3_decel",
	style = "popin 60%",
})
hl.animation({
	leaf = "windowsIn",
	enabled = true,
	speed = 3,
	bezier = "md_3_decel",
	style = "popin 60%",
})
hl.animation({
	leaf = "windowsOut",
	enabled = true,
	speed = 3,
	bezier = "md_3_accel",
	style = "popin 60%",
})
hl.animation({
	leaf = "border",
	enabled = true,
	speed = 10,
	bezier = "default",
})
hl.animation({
	leaf = "fade",
	enabled = true,
	speed = 3,
	bezier = "md_3_decel",
})
-- flash of hover.lua
hl.animation({
	leaf = "fadeSwitch",
	enabled = true,
	speed = 1.5,
	bezier = "md_3_decel",
})
hl.animation({
	leaf = "layersIn",
	enabled = true,
	speed = 3,
	bezier = "popin",
	style = "slide",
})
hl.animation({
	leaf = "layersOut",
	enabled = true,
	speed = 1.6,
	bezier = "menu_accel",
})
hl.animation({
	leaf = "fadeLayersIn",
	enabled = true,
	speed = 2,
	bezier = "menu_decel",
})
hl.animation({
	leaf = "fadeLayersOut",
	enabled = true,
	speed = 4.5,
	bezier = "menu_accel",
})
hl.animation({
	leaf = "workspaces",
	enabled = true,
	speed = 7,
	bezier = "menu_decel",
	-- workspaces up/down, columns left/right (like niri)
	style = "slidevert",
})
hl.animation({
	leaf = "specialWorkspace",
	enabled = true,
	speed = 3,
	bezier = "md_3_decel",
	style = "slidevert",
})
