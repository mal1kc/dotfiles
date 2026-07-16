-- TODO: manual review — plugin section ''. The new Lua API exposes plugins via hl.plugin.<name>(...) — wire up per the plugin's docs.
--[[
  -- hyprwinwrap { ... }
  -- Desktop
  -- hyprexpo { ... }
  -- hyprbars { ... }
]]

hl.bind("SUPER + TAB", hl.plugin.hymission.toggle)
hl.bind("SUPER + SHIFT + A", function()
	hl.plugin.hymission.toggle("forceall")
end)
hl.bind("SUPER + A", function()
	hl.plugin.hymission.open("onlycurrentworkspace")
end)
hl.bind("SUPER + Escape", hl.plugin.hymission.close)
