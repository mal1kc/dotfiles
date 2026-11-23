local mainMod = MainMod -- set in hyprland.lua

-- like niri: workspaces up/down, columns left/right
hl.gesture({ fingers = 3, direction = "vertical", action = "workspace" })
hl.gesture({ fingers = 3, direction = "horizontal", action = "scroll_move" })

hl.gesture({ fingers = 3, direction = "down", mods = "ALT", action = "close" })
hl.gesture({ fingers = 3, direction = "up", mods = mainMod, scale = 1.5, action = "fullscreen" })

hl.gesture({ fingers = 3, direction = "left", mods = mainMod, scale = 1.5, action = "resize" })
hl.gesture({ fingers = 3, direction = "right", mods = mainMod, scale = 1.5, action = "resize" })

hl.gesture({
	fingers = 4,
	direction = "down",
	action = function()
		hl.dispatch(hl.dsp.window.cycle_next())
	end,
})

hl.gesture({
	fingers = 2,
	direction = "pinch",
	mods = mainMod,
	action = "resize",
})

hl.gesture({
	fingers = 3,
	direction = "swipe",
	mods = mainMod .. " + SHIFT",
	action = "fullscreen",
})
