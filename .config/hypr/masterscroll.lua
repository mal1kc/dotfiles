-- Master pinned on one side (left at start), stack on the other one that scrolls
-- up/down to keep the focused window in view. Returns the layout name for workspace rules.
--
-- The stack scrolls vertically because windows placed past the left/right edge
-- would show up on the monitor next to it.
-- Master side and sizes are per workspace and reset by a config reload.
-- Hyprland doesn't tell lua layouts how far a resize goes, so mouse resizes
-- follow the cursor (Util.mouse_resize, set in binds.lua) and the resize submap
-- sends "resize <x> <y>".

local NAME = "lua:masterscroll"
local VISIBLE = 2 -- stack windows on screen
local WIDTHS = { 0.4, 0.5, 0.6, 0.7, 0.8 } -- steps of colresize +conf/-conf

local states = {} -- workspace name -> { name, mfact, ratio, top, side }

local function state_of(ctx)
	local name = ""
	for _, target in ipairs(ctx.targets) do
		local window = target.window
		if window and window.workspace then
			name = window.workspace.name or ""
			break
		end
	end
	-- ratio: height of the upper one of the two visible stack windows
	states[name] = states[name] or { name = name, mfact = 0.6, ratio = 0.5, top = 1, side = "left" }
	return states[name]
end

-- The first target is the master, the others are the stack from top to bottom.
-- Replacing the master swaps targets, like the master layout does.
local function focused_index(ctx)
	for i, target in ipairs(ctx.targets) do
		if target.window and target.window.active then
			return i
		end
	end
end

local function clamp(value)
	return math.max(0.2, math.min(0.8, value))
end

-- move the border between master and stack / between the two stack windows
local function move_borders(ctx, state, dx, dy)
	state.mfact = clamp(state.mfact + (state.side == "left" and dx or -dx) / ctx.area.w)
	state.ratio = clamp(state.ratio + dy / ctx.area.h)
end

-- SUPER + right mouse button: the borders follow the cursor
local function follow_mouse(ctx, state)
	local drag = Util.mouse_resize
	local pos = drag and drag.workspace == state.name and hl.get_cursor_pos()
	if not pos then
		return
	end
	-- sideways on the master, both directions on the stack
	local on_stack = (pos.x - ctx.area.x) / ctx.area.w > state.mfact
	if state.side == "right" then
		on_stack = (pos.x - ctx.area.x) / ctx.area.w < 1 - state.mfact
	end
	if drag.on_stack == nil then
		drag.on_stack = on_stack
	end
	move_borders(ctx, state, pos.x - drag.x, drag.on_stack and pos.y - drag.y or 0)
	drag.x, drag.y = pos.x, pos.y
end

local function recalculate(ctx)
	local state = state_of(ctx)
	follow_mouse(ctx, state)
	local master = ctx.targets[1]
	if not master then
		return
	end
	local count = #ctx.targets - 1 -- stack
	if count == 0 then
		master:place(ctx.area)
		return
	end

	local rows = math.min(count, VISIBLE)
	local focused = (focused_index(ctx) or 1) - 1 -- 0: not in the stack
	local top = state.top
	if focused > 0 and focused < top then
		top = focused
	elseif focused > top + rows - 1 then
		top = focused - rows + 1
	end
	state.top = math.max(1, math.min(top, count - rows + 1))

	master:place(ctx:split(ctx.area, state.side, state.mfact))

	local stack_side = state.side == "left" and "right" or "left"
	local side = ctx:split(ctx.area, stack_side, 1 - state.mfact)
	-- upper: first visible one and those scrolled out above it, lower: the rest
	local upper = rows > 1 and side.h * state.ratio or side.h
	local lower = side.h - upper
	if rows == 1 then
		lower = side.h
	end
	for i = 1, count do
		local offset = i - state.top
		ctx.targets[i + 1]:place({
			x = side.x,
			y = side.y + (offset <= 0 and offset * upper or upper + (offset - 1) * lower),
			w = side.w,
			h = offset <= 0 and upper or lower,
		})
	end
end

local function next_width(current, step)
	if step > 0 then
		for _, width in ipairs(WIDTHS) do
			if width > current + 0.001 then
				return width
			end
		end
		return WIDTHS[#WIDTHS]
	end
	for i = #WIDTHS, 1, -1 do
		if WIDTHS[i] < current - 0.001 then
			return WIDTHS[i]
		end
	end
	return WIDTHS[1]
end

-- swap the focused window with another one, focus stays on it
local function swap_with(target)
	if target and target.window then
		hl.dispatch(hl.dsp.window.swap({ target = target.window }))
	end
end

-- index of the window to swap with when the focused one moves in a direction
local function neighbor(state, focused, direction)
	local to_master = state.side == "left" and "l" or "r"
	if focused == 1 then
		-- master: only towards the stack
		local sideways = direction == "l" or direction == "r"
		return sideways and direction ~= to_master and 1 + state.top or nil
	end
	if direction == to_master then
		return 1
	elseif direction == "u" and focused > 2 then
		return focused - 1
	elseif direction == "d" then
		return focused + 1
	end
end

local function layout_msg(ctx, msg)
	local state = state_of(ctx)
	local focused = focused_index(ctx) -- nil: a floating window
	local command, arg, arg2 = msg:match("^(%S+)%s*(%S*)%s*(%S*)")

	if command == "colresize" then
		if arg == "+conf" then
			state.mfact = next_width(state.mfact, 1)
		elseif arg == "-conf" then
			state.mfact = next_width(state.mfact, -1)
		elseif tonumber(arg) then
			state.mfact = clamp(tonumber(arg))
		end
	elseif focused and command == "resize" then
		-- grow the focused window by x, y pixels
		local dx, dy = tonumber(arg) or 0, tonumber(arg2) or 0
		local right_of_border = (focused > 1) == (state.side == "left")
		local lower = focused - 1 > state.top
		if focused == 1 then
			dy = 0
		end
		move_borders(ctx, state, right_of_border and -dx or dx, lower and -dy or dy)
	elseif command == "orientationleft" or command == "orientationright" then
		state.side = command == "orientationleft" and "left" or "right"
	elseif focused and command == "promote" then
		-- become master; the master swaps with the first visible stack window
		swap_with(ctx.targets[focused > 1 and 1 or 1 + state.top])
	elseif focused and command == "swapcol" then
		-- one place earlier / later
		swap_with(ctx.targets[focused + (arg == "l" and -1 or 1)])
	elseif focused and command == "move" then
		if arg == "+col" or arg == "-col" then
			-- wheel: focus goes through master and stack
			local target = ctx.targets[focused + (arg == "+col" and 1 or -1)]
			if target and target.window then
				hl.dispatch(hl.dsp.focus({ window = target.window }))
			end
		else
			local index = neighbor(state, focused, arg)
			swap_with(index and ctx.targets[index])
		end
	end
	-- "refresh" and scrolling-only messages: Hyprland recalculates anyway
	return true
end

hl.layout.register("masterscroll", {
	recalculate = recalculate,
	layout_msg = layout_msg,
})

-- focus changes don't recalculate a layout by themselves
hl.on("window.active", function(window)
	local workspace = window and not window.floating and window.workspace
	if not workspace or workspace.tiled_layout ~= NAME then
		return
	end
	-- only if the message will reach that workspace
	local active = Util.layout_workspace()
	if active and active.name == workspace.name then
		hl.dispatch(hl.dsp.layout("refresh"))
	end
end)

return NAME
