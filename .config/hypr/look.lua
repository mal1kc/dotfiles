hl.config({
	debug = {
		disable_logs = false,
		vfr = true,
	},
	general = {
		gaps_in = 3,
		gaps_out = 7,
		border_size = 2,
		col = {
			active_border = { colors = { "rgba(33ccffee)", "rgba(00ff99ee)" }, angle = 45 },
			inactive_border = "rgba(595959aa)",
		},
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
	misc = {
		enable_swallow = true,
		swallow_regex = "^(St)$",
		swallow_exception_regex = "^(wev)$",
		on_focus_under_fullscreen = 2, -- unfullscreen/unmaximize
		-- focus_on_activate: machine.lua
		animate_manual_resizes = true,
	},
})
