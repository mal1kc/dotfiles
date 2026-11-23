local M = {}

-- workspace that layout messages go to: an open scratchpad comes first
function M.layout_workspace()
	return hl.get_active_special_workspace() or hl.get_active_workspace()
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
