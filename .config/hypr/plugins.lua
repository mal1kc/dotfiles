-- TODO: manual review — plugin section ''. The new Lua API exposes plugins via hl.plugin.<name>(...) — wire up per the plugin's docs.
--[[
  -- hyprwinwrap { ... }
  -- Desktop
  -- hyprexpo { ... }
  -- hyprbars { ... }
]]

hl.bind("SUPER + TAB", hl.plugin.overview.toggle)

-- all windows
hl.bind("SUPER + SHIFT + A", function()
	hl.plugin.overview.toggle("all")
end)
hl.bind("SUPER + A", function()
	hl.plugin.overview.open("onlycurrentworkspace")
end)
hl.bind("SUPER + Escape", hl.plugin.overview.close)

hl.config({
	plugin = {
		overview = {
			panelBorderColor = "#33ccff",

			onBottom = false,
			autoDrag = false,
			autoScroll = false,
			showNewWorkspace = true,
			switchOnDrop = true,

			hideOverlayLayers = true,
			hideBackgroundLayers = true,

			hideRealLayers = true,
			affectStrut = false,
		},
	},
})
