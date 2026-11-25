local M = {}

-- workspace that layout messages go to: an open scratchpad comes first
function M.layout_workspace()
	return hl.get_active_special_workspace() or hl.get_active_workspace()
end

-- give the current workspace another layout until a reload (a new workspace
-- rule is how hyprland changes a layout at runtime): "scrolling", "master",
-- "dwindle", "monocle" or "masterscroll".
-- Global through Util, so the SUPER + P menu can run it: hyprctl eval
function M.set_layout(layout)
	local function notify(text, icon)
		hl.notification.create({ text = text, icon = icon, timeout = 3000, font_size = 16 })
	end
	local name = layout
	if layout == "masterscroll" then
		local found, registered = pcall(require, "masterscroll")
		if not (found and registered) then
			notify("Layout: masterscroll isn't loaded (masterscroll.lua)", "error")
			return
		end
		name = registered
	end
	local workspace = M.layout_workspace()
	if not workspace then
		notify("Layout: no active workspace", "error")
		return
	end
	local special = hl.get_active_special_workspace()
	local rule = special and workspace.name or tostring(workspace.id)
	local ok, err = pcall(hl.workspace_rule, { workspace = rule, layout = name })
	if not ok then
		notify("Layout " .. layout .. ": " .. tostring(err), "error")
		return
	end
	notify("Workspace " .. rule .. ": " .. layout, "info")
end

-- current workspace: masterscroll <-> scrolling
function M.toggle_masterscroll()
	local workspace = M.layout_workspace()
	local masterscroll = workspace and workspace.tiled_layout == "lua:masterscroll"
	M.set_layout(masterscroll and "scrolling" or "masterscroll")
end

-- is the point inside the window (its tiled/floating box)
function M.inside(window, pos)
	local at, size = window.at, window.size
	return at
		and size
		and pos.x >= at.x
		and pos.y >= at.y
		and pos.x < at.x + size.x
		and pos.y < at.y + size.y
end

-- a visible floating window at that point, other than `except`
function M.floating_at(pos, except)
	for _, window in ipairs(hl.get_windows({ floating = true })) do
		-- `visible` is also true on workspaces that aren't shown
		local shown = window.visible and (window.pinned or (window.workspace and window.workspace.active))
		if shown and M.inside(window, pos) and not (except and window.address == except.address) then
			return window
		end
	end
end

return M
