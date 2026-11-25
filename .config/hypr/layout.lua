-- scrolling everywhere, except the workspaces below

Util.MachineSpecificCfg(hl.config, {
	scrolling = {
		column_width = 0.5,
		follow_min_visible = 0.1,
	},
}, "desktop")

Util.MachineSpecificCfg(hl.config, {
	scrolling = {
		focus_fit_method = 1,
		column_width = 0.6,
		follow_min_visible = 0.15,
	},
}, "laptop")

hl.config({
	general = {
		-- layout = dwindle
		layout = "scrolling",
	},
	scrolling = {
		direction = "right",
		-- a lone window fills the screen
		fullscreen_on_one_column = true,
		-- steps of SUPER + minus / asterisk
		explicit_column_widths = "0.333, 0.4, 0.5, 0.6, 0.75, 1.0",
	},
	dwindle = {
		preserve_split = true, -- you probably want this
	},
	master = {
		-- new_status = master
		mfact = 0.6,
		center_master_fallback = "right",
	},
})

hl.workspace_rule({
	workspace = "5",
	layout = "monocle",
})

-- pinned master + scrolling stack on 6, the rest starts scrolling
-- (SUPER + SHIFT + M or the SUPER + P menu switches the current workspace)
local found, masterscroll = pcall(require, "masterscroll")
if found and masterscroll then
	for _, workspace in ipairs({ "6" }) do
		hl.workspace_rule({
			workspace = workspace,
			layout = masterscroll,
		})
	end
end
